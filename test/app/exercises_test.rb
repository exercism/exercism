require_relative '../app_helper'

class AppExercisesTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismWeb::App
  end

  def test_unlock_nitpicking
    alice = User.create(username: 'alice', github_id: 1)
    Submission.create(user: alice, language: 'ruby', slug: 'bob')
    Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'bob').update

    post '/exercises/ruby/bob', {}, login(alice)

    exercise = Exercise.new('ruby', 'bob')
    assert alice.reload.nitpicker_on?(exercise)
  end

  def test_unlock_nitpicking_fails_if_no_submissions
    alice = User.create(username: 'alice', github_id: 1)
    post '/exercises/ruby/bob', {}, login(alice)

    exercise = Exercise.new('ruby', 'bob')
    refute alice.reload.nitpicker_on?(exercise)
  end
end
