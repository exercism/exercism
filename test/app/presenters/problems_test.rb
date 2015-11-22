require_relative '../../test_helper'
require_relative '../../app_presenters_helper'
require_relative '../../api_helper'
require 'mocha/setup'
require_relative '../../../app/presenters/problems'
require_relative '../../api_helper.rb'
require_relative '../../app_helper.rb'

class PresentersProblemsTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismWeb::App
  end

  def test_knows_its_track_id
    track = ExercismWeb::Presenters::Special::Problems.new("ruby")
    assert_equal "ruby", track.track_id
  end

  def all_problems_json
    File.read("./test/fixtures/approvals/api_all_problems.approved.json")
  end

  def test_that_fetch_all_problems_can_get_all_problems
    Xapi.stub(:get, [200, all_problems_json]) do
      get '/problems'
      problems = ExercismWeb::Presenters::Special::Problems.new('ruby')
      assert_includes problems.fetch_all_problems.to_s, '"slug"=>"zipper"'
    end
  end

  def test_can_return_problems_for_specific_track
    Xapi.stub(:get, [200, all_problems_json]) do
      get '/languages/ruby'
      problems = ExercismWeb::Presenters::Special::Problems.new('ruby')
      assert_includes problems.track_problems.to_s, "Write a program that implements a binary search algorithm."
    end
  end
end
