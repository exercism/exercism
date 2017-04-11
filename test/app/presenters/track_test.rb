require_relative '../../test_helper'
require_relative '../../../app/presenters/track'
require_relative '../../api_helper'
require 'mocha/setup'

class PresentersTrackTest < Minitest::Test
  def setup
    @track = ExercismWeb::Presenters::Track.new("test_track")
    @trackler_track = Object.new
    @track.stubs(:trackler_track).returns(@trackler_track)
    @track.stubs(:default_topic_content).returns("Default topic content")
  end

  def test_docs_with_trackler_content
    trackler_docs = OpenStruct.new(test_topic: "Track-specific content from Trackler")
    @trackler_track.stubs(:docs).returns(trackler_docs)
    assert_equal @track.docs["test_topic"], "Track-specific content from Trackler"
  end

  def test_docs_without_trackler_content
    trackler_docs = OpenStruct.new(test_topic: "")
    @trackler_track.stubs(:docs).returns(trackler_docs)
    assert_equal @track.docs["test_topic"], "Default topic content"
  end

  def test_method_delegated_to_trackler_track
    @trackler_track.stubs(:exists?).returns(true)
    assert_equal @track.exists?, true
  end
end
