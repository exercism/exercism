require_relative '../../app_helper'
require 'mocha/setup'

require 'exercism/submission'
require 'app/presenters/workload'

class WorkloadTest < Minitest::Test
  include AppTestHelper
  include Rack::Test::Methods
  include DBCleaner

  attr_reader :master, :marjo, :alex

  def setup
    super

    create_users
    create_submissions
  end

  def create_users
    @master = User.create({
      username: 'master', github_id: 1, email: "master@example.com",
      mastery: %w(ruby python)
    })

    @marjo = User.create({
      username: 'marjo', github_id: 2, email: "marjo@example.com"
    })

    @alex = User.create({
      username: 'alex', github_id: 3, email: "alex@example.com"
    })
  end

  def create_submissions
    Attempt.new(alex, Iteration.new({'ruby/beer-song/beer-song.rb' => 'CODE'}, {track: 'ruby', slug: 'beer-song'})).save
   Attempt.new(alex, Iteration.new({'ruby/bob/bob.rb' => 'CODE'}, {track: 'ruby', slug: 'bob'})).save
   Attempt.new(marjo, Iteration.new({'ruby/bob/bob.rb' => 'CODE'}, {track: 'ruby', slug: 'bob'})).save
   Attempt.new(alex, Iteration.new({'ruby/word-count/word-count.rb' => 'CODE'}, {track: 'ruby', slug: 'word-count'})).save

    alex.submissions.first.like!(marjo)
    alex.submissions.last.update_attributes(state: 'needs_input')
    marjo.submissions.first.like!(alex)
  end

  def test_groups_submissions_by_exercise_slug
    workload = Workload.new(master, "ruby", "bob")

    expected = {
      "beer-song" => 1, "bob" => 2, "word-count" => 1
    }

    assert_equal expected, workload.breakdown
  end

  def test_submissions_with_given_no_nits_as_slug
    workload = Workload.new(master, "ruby", "no-nits")

    assert_equal 4, workload.submissions.count
  end

  def test_submissions_with_given_looks_great_as_slug
    workload = Workload.new(master, "ruby", "looks-great")

    assert_equal 2, workload.submissions.count
  end

  def test_submissions_with_given_needs_input_as_slug
    workload = Workload.new(master, "ruby", "bob")

    assert_equal 2, workload.submissions.count
  end

  def test_submissions_with_given_exercise_as_slug
    workload = Workload.new(master, "ruby", "bob")

    assert_equal 2, workload.submissions.count
  end

  def test_doesnt_see_own_exercises
    workload = Workload.new(marjo, "ruby", "bob")

    assert_equal 1, workload.submissions.count
    Xapi.stub(:get, [200, language_tracks_json]) do
      assert_equal 1, workload.available_exercises.count
    end
  end

  def test_sort_exercises_by_language_track
    workload = Workload.new(master, "ruby", "aging")

    Xapi.stub(:get, [200, language_tracks_json]) do
      assert_equal %w(word-count bob beer-song), workload.available_exercises.map(&:slug)
    end
  end
end
