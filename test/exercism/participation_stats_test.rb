require_relative '../integration_helper'

class ParticipationStatsTest < MiniTest::Test
  include DBCleaner

  def setup
    super
    experimental = User.create!(username: 'experimental', created_at: '2015-01-01')
    experimental.comments.create!(created_at: Date.yesterday, submission_id: 1, body: 'hi')
    experimental.comments.create!(created_at: Date.yesterday, submission_id: 1, body: 'not bad')
    experimental.comments.create!(created_at: Date.today, submission_id: 1, body: 'not counted until tomorrow')
    control = User.create!(username: 'control_grp', created_at: '2015-01-01')
    control.comments.create!(created_at: 1.year.ago, submission_id: 1, body: 'old')
    control.comments.create!(created_at: Date.yesterday, submission_id: 1, body: 'nice')
    opted_out = User.create!(username: 'opted_out', created_at: '2015-01-01', motivation_experiment_opt_out: true)
    opted_out.comments.create!(created_at: Date.yesterday, submission_id: 1, body: 'not counted in control group since user opted out')
    newcomer = User.create!(username: 'newcomer')
    newcomer.comments.create!(created_at: Date.yesterday, submission_id: 1, body: 'not counted in expermiental group since user just joined')
  end

  def test_experiment_complete?
    assert_includes [true, false], ParticipationStats.experiment_complete?
  end

  def test_counts
    yesterday_date_string = Date.yesterday.strftime('%F')

    stats = ParticipationStats.new(date_range: 1.week.ago..1.week.from_now)

    assert_equal 1, stats.avg_daily_reviews_per_user_by_period.size
    assert_equal [2, 1, 1, 1], stats.avg_daily_reviews_per_user_by_period.first.last
    assert_equal [2, 4, 7, 49, 56], stats.review_lengths_by_period.first.last.sort
  end

  def test_to_json
    stats = ParticipationStats.new(date_range: 1.week.ago..1.week.from_now)

    json = stats.results.to_json
    data = JSON.parse(json)

    assert_includes data.keys, 'avg_daily_reviews_per_user_by_period'
    assert_includes data.keys, 'review_lengths_by_period'
  end

  def test_experimental_groups
    stats = ParticipationStats.new(
      date_range: 1.week.ago..1.week.from_now,
      experiment_group: :experimental
    )
    assert_equal 2, stats.avg_daily_reviews_per_user_by_period.first.flatten.last

    stats = ParticipationStats.new(
      date_range: 1.week.ago..1.week.from_now,
      experiment_group: :control
    )
    assert_equal 1, stats.avg_daily_reviews_per_user_by_period.first.flatten.last
  end
end
