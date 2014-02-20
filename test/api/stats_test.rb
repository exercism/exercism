require './test/api_helper'
require 'timecop'

class StatsApiTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismAPI
  end

  def test_empty_snapshot
    User.create(username: 'alice', github_id: 1, created_at: 8.days.ago)

    get '/stats/alice/snapshot'

    Approvals.verify(last_response.body, name: 'stats_empty_snapshot', format: :json)
  end

  def test_snapshot
    Timecop.freeze(Time.utc(2014, 1, 1)) do
      alice = User.create(username: 'alice', github_id: 1, created_at: 30.days.ago)
      bob = User.create(username: 'bob', github_id: 2, created_at: 20.days.ago)

      Submission.create(user: alice, created_at: 4.days.ago, slug: 'leap', language: 'python', state: 'pending')
      Submission.create(user: alice, created_at: 6.days.ago, slug: 'leap', language: 'ruby', state: 'done')
      Submission.create(user: alice, created_at: 8.days.ago, slug: 'word-count', language: 'ruby', state: 'done')
      Submission.create(user: alice, created_at: 9.days.ago, slug: 'anagram', language: 'ruby', state: 'pending')
      Submission.create(user: alice, created_at: 9.days.ago, slug: 'bob', language: 'ruby', state: 'done')

      Submission.create(user: alice, created_at: 29.days.ago, slug: 'leap', language: 'go', state: 'hibernating')

      Hack::UpdatesUserExercise.new(alice.id, 'python', 'leap').update
      Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'anagram').update
      Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'leap').update
      Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'bob').update
      Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'word-count').update
      Hack::UpdatesUserExercise.new(alice.id, 'go', 'leap').update

      submission = Submission.create(language: 'ruby', slug: 'leap', user: bob, created_at: 15.days.ago)
      Hack::UpdatesUserExercise.new(bob.id, 'ruby', 'word-count').update
      Comment.create(user_id: alice.id, body: 'testing', submission_id: submission.id, created_at: 8.days.ago)
      Comment.create(user_id: alice.id, body: 'testing', submission_id: submission.id, created_at: 6.days.ago)

      get '/stats/alice/snapshot'

      Approvals.verify(last_response.body, name: 'stats_snapshot', format: :json)
    end
  end
end

