require_relative '../../app_helper'
require 'mocha/setup'

require 'exercism/submission'
require 'app/presenters/workload'

class WorkloadTest < MiniTest::Test
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
    Attempt.new(alex, "code", 'beer-song/beer-song.rb').save
    Attempt.new(alex, "code", 'bob/bob.rb').save
    Attempt.new(marjo, "code", "bob/bob.rb").save
    Attempt.new(marjo, "code", "word_count/word_count.rb").save

    alex.submissions.first.like!(marjo)
    alex.submissions.last.update_attributes(state: 'needs_input')
    marjo.submissions.first.like!(alex)
  end

  def test_groups_submissions_by_exercise_slug
    workload = Workload.new(master, "ruby", "bob")

    expected = {
      "beer-song" => 1, "bob" => 2, "word_count" => 1
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
    assert_equal 1, workload.available_exercises.count
  end
end
