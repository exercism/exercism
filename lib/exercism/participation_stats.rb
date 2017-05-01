require 'date'

class ParticipationStats
  PRE_GAMIFICATION_COMPARISON_DATE = '2017-03-11'
  GAMIFICATION_START_DATE          = '2017-03-27'
  GAMIFICATION_WITHDRAWAL_DATE     = '2017-04-12'
  GAMIFICATION_EXPERIMENT_END_DATE = '2017-04-28'

  attr_reader :date_range, :experiment_group

  def self.experiment_complete?
    Time.now > Date.parse(GAMIFICATION_EXPERIMENT_END_DATE) + 1.day
  end

  def initialize(date_range: experiment_date_range, experiment_group: nil)
    @date_range = date_range
    @experiment_group = experiment_group
  end

  def results
    {
      avg_daily_reviews_per_user_by_period: avg_daily_reviews_per_user_by_period,
      review_lengths_by_period: review_lengths_by_period,
    }
  end

  # {period_name => [1, 1, 12, ... number of comments per user]}
  def avg_daily_reviews_per_user_by_period
    result = query_results.map do |attrs|
      counts = attrs['user_comment_counts'].split(',').map(&:to_i)
      counts = fill_zeros_for_participating_users_with_no_comments_represented(counts)
      [attrs['period'], counts]
    end
    Hash[result]
  end

  # {period_name => [12, 251, 40, ... length of each comment's body]}
  def review_lengths_by_period
    result = query_results.map do |attrs|
      counts = attrs['comment_lengths'].split(',').map(&:to_i)
      counts = fill_zeros_for_participating_users_with_no_comments_represented(counts)
      [attrs['period'], counts]
    end
    Hash[result]
  end

  def fill_zeros_for_participating_users_with_no_comments_represented(comment_counts)
    comment_counts.fill(0, comment_counts.size...participating_user_count)
  end

  def participating_user_count
    @participating_user_count ||= begin
      relation = Comment.
        joins(:user).
        select('count(DISTINCT users.id) AS participating_user_count')
      relation = filter_experiment_period(relation)
      relation = filter_experiment_group(relation)
      relation.take.participating_user_count
    end
  end

  private

  # [{'period' => 'first_period_name',
  #   'user_comment_counts' => '1,1,12',
  #   'comment_lengths' => '12,251,40'},
  #  ...]
  def query_results
    @query_results ||= time { ActiveRecord::Base.connection.execute(sql).to_a }
  end

  # Subselect: For each period, select one row per user with user comment count
  #            and comment lengths.
  # Then condense the results down to one row per period, aggregating all the
  # results using comma-separated lists.
  def sql
    select =
      <<~SELECT
        CASE WHEN comments.created_at < '#{GAMIFICATION_START_DATE}'
               THEN '1-pre-gamification'
             WHEN comments.created_at < '#{GAMIFICATION_WITHDRAWAL_DATE}'
               THEN '2-gamification'
             ELSE   '3-withdrawal'
             END AS period,
        count(comments.id) AS user_comment_count,
        array_to_string(array_agg(length(comments.body)), ',') AS comment_lengths
      SELECT
    user_comment_counts_and_lengths = Comment.
      select(select).
      joins(:user).
      group('period, users.id').
      order('period')
    user_comment_counts_and_lengths = filter_experiment_period(user_comment_counts_and_lengths)
    user_comment_counts_and_lengths = filter_experiment_group(user_comment_counts_and_lengths)
    grouped_by_period = Comment.
      from(user_comment_counts_and_lengths).
      group('period').
      select(<<~SELECT)
        period,
        array_to_string(array_agg(user_comment_count), ',') AS user_comment_counts,
        array_to_string(array_agg(comment_lengths), ',') AS comment_lengths
      SELECT
    grouped_by_period.to_sql
  end

  def filter_experiment_period(relation)
    end_date = (Date.today <= date_range.last) ? Date.today : date_range.last
    relation.
      where('comments.created_at >= ?', date_range.first).
      where('comments.created_at <  ?', end_date)
  end

  def filter_experiment_group(relation)
    return relation if experiment_group.nil?
    relation = filter_opt_out(relation)
    relation = filter_late_arrivals(relation)
    case experiment_group
    when :control
      relation.where('crc32(users.username) % 100 >= 50')
    when :experimental
      relation.where('crc32(users.username) % 100 < 50')
    else
      fail 'experiment_group must be :control, :experimental, or nil'
    end
  end

  def filter_opt_out(relation)
    relation.where('users.motivation_experiment_opt_out' => false)
  end

  def filter_late_arrivals(relation)
    relation.where('users.created_at < ?', PRE_GAMIFICATION_COMPARISON_DATE)
  end

  def time(&block)
    Metrics.time 'exercism_io.stats.experiment.query.time', &block
  end

  def experiment_date_range
    start_date = Date.parse(PRE_GAMIFICATION_COMPARISON_DATE)
    end_date = Date.parse(GAMIFICATION_EXPERIMENT_END_DATE)
    start_date..end_date
  end
end
