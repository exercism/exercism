require_relative '../integration_helper'

class ParticipationStatsTest < MiniTest::Test
  include DBCleaner

  def setup
    super
    experimental = User.create!(username: 'experimental')
    experimental.comments.create!(created_at: Time.now, submission_id: 1, body: 'hi')
    experimental.comments.create!(created_at: Time.now, submission_id: 1, body: 'not bad')
    control = User.create!(username: 'control_grp')
    control.comments.create!(created_at: 1.year.ago, submission_id: 1, body: 'old')
    control.comments.create!(created_at: Time.now, submission_id: 1, body: 'nice')
  end

  def test_counts
    today_date_string = Time.now.utc.strftime('%F')

    stats = ParticipationStats.new(1.week.ago..1.week.from_now)

    assert_equal 1, stats.dates.size
    assert_equal today_date_string, stats.dates.first
    assert_equal 1, stats.daily_review_count.size
    assert_equal 3, stats.daily_review_count.first
    assert_equal [2, 4, 7], stats.daily_review_lengths.first.sort
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
