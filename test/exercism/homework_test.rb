require_relative '../test_helper'
require_relative '../active_record_helper'
require_relative '../../lib/exercism'
require_relative '../../lib/exercism/homework'

class HomeworkTest < Minitest::Test
  include DBCleaner

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def test_status
    alice = User.create(username: 'alice')
    homework = Homework.new(alice)
    now = Time.now.utc
    attributes = { user: alice, language: 'ruby' }

    UserExercise.create(attributes.merge(slug: 'leap', skipped_at: now))
    UserExercise.create(attributes.merge(slug: 'clock', fetched_at: now, iteration_count: 0))
    UserExercise.create(attributes.merge(slug: 'submssion', fetched_at: now, iteration_count: 1, last_iteration_at: now))
    UserExercise.create(attributes.merge(slug: 'gigasecond', last_iteration_at: now))

    assert_equal homework.status('ruby').to_json, {
      track_id: 'ruby',
      recent: {
        problem: 'gigasecond',
        submitted_at: now
      },
      skipped: ['leap'],
      submitted: ['submssion'],
      fetched: ['clock']
    }.to_json

    assert_equal homework.status('go').to_json, {
      track_id: 'go',
      recent: {
        problem: '',
        submitted_at: ''
      },
      skipped: [],
      submitted: [],
      fetched: []
    }.to_json
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
