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

    stats = ParticipationStats.new(1.week.ago..1.week.from_now)

    assert_equal 1, stats.dates.size
    assert_equal yesterday_date_string, stats.dates.first
    assert_equal 1, stats.daily_review_count.size
    assert_equal 5, stats.daily_review_count.first
    assert_equal [2, 4, 7, 49, 56], stats.daily_review_lengths.first.sort
  end

  def test_to_json
    stats = ParticipationStats.new(
      1.week.ago..1.week.from_now,
      gamification_markers: true
    )

    json = stats.results.to_json
    data = JSON.parse(json)

    assert data.has_key?('dates'), 'data missing key: dates'
    assert data.has_key?('gamification_start_date'), 'data missing key: gamification_start_date'
  end

  def test_experimental_groups
    stats = ParticipationStats.new(
      1.week.ago..1.week.from_now,
      experiment_group: :experimental
    )
    assert_equal 2, stats.daily_review_count.first

    stats = ParticipationStats.new(
      1.week.ago..1.week.from_now,
      experiment_group: :control
    )
    assert_equal 1, stats.daily_review_count.first
  end
end
