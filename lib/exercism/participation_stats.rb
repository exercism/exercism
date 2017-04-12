require 'date'

class ParticipationStats
  PRE_GAMIFICATION_COMPARISON_DATE = '2017-03-13'
  GAMIFICATION_START_DATE          = '2017-03-27'
  GAMIFICATION_WITHDRAWAL_DATE     = '2017-04-12'
  GAMIFICATION_EXPERIMENT_END_DATE = '2017-04-26'
  GAMIFICATION_MARKERS = {
    gamification_start_date: GAMIFICATION_START_DATE,
    gamification_withdrawal_date: GAMIFICATION_WITHDRAWAL_DATE,
    gamification_experiment_end_date: GAMIFICATION_EXPERIMENT_END_DATE,
  }.freeze

  attr_reader :date_range, :gamification_markers, :experiment_group

  def self.experiment_complete?
    Time.now > Date.parse(GAMIFICATION_EXPERIMENT_END_DATE) + 1.day
  end

  def initialize(date_range, gamification_markers: false, experiment_group: nil)
    @date_range = date_range
    @gamification_markers = gamification_markers
    @experiment_group = experiment_group
  end

  def results
    result = {
      dates: dates,
      daily_review_count: daily_review_count,
      daily_review_lengths: daily_review_lengths,
    }
    result.merge!(GAMIFICATION_MARKERS) if gamification_markers
    result
  end

  def dates
    query_results.map { |result| result['created_date'] }
  end

  def daily_review_count
    query_results.map { |result| result['comment_count'].to_i }
  end

  def daily_review_lengths
    query_results.map { |result| result['comment_lengths'].split(',').map(&:to_i) }
  end

  private

  def query_results
    @query_results ||= time { ActiveRecord::Base.connection.execute(sql).to_a }
  end

  def sql
    end_date = (Date.today <= date_range.last) ? Date.today : date_range.last
    relation = Comment.
      select(
        <<~SELECT
          date(date_trunc('day', comments.created_at)) AS created_date,
          count(comments.created_at) AS comment_count,
          array_to_string(array_agg(length(body)), ',') AS comment_lengths
        SELECT
      ).
      joins(:user).
      where('comments.created_at >= ?', date_range.first).
      where('comments.created_at <  ?', end_date).
      group('created_date').
      order('created_date')
    relation = filter_experiment_group(relation)
    relation.to_sql
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
end
