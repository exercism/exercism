require_relative '../../test_helper'
require_relative '../../../app/presenters/track'
require_relative '../../api_helper'
require 'mocha/setup'

class PresentersTrackTest < Minitest::Test
  def setup
    @track = ExercismWeb::Presenters::Track.new("test_track")
    @trackler_track = Object.new

    @track.stubs(:trackler_track).returns(@trackler_track)
    @track.stubs(:fallback_topic_content).returns("Default topic content")

    @trackler_track.stubs(:repository).returns("https://github.com/exercism/test_track")
    @trackler_track.stubs(:doc_format).returns("md")
  end

  def test_docs_with_trackler_content
    trackler_docs = OpenStruct.new(test_topic: "Track-specific content from Trackler")
    @trackler_track.stubs(:docs).returns(trackler_docs)
    topic_doc = @track.docs["test_topic"]

    assert topic_doc.include?("Track-specific content from Trackler")
    assert topic_doc.include?("Help us explain this better!")
    assert topic_doc.include?("File a GitHub issue at https://github.com/exercism/test_track")
    assert topic_doc.include?("https://github.com/exercism/test_track/blob/master/docs/TEST_TOPIC.md")
  end

  def test_docs_without_trackler_content
    trackler_docs = OpenStruct.new(test_topic: "")
    @trackler_track.stubs(:docs).returns(trackler_docs)
    topic_doc = @track.docs["test_topic"]

    assert topic_doc.include? "Default topic content"
    assert !topic_doc.include?("Help us explain this better!")
    assert !topic_doc.include?("File a GitHub issue at https://github.com/exercism/test_track")
    assert !topic_doc.include?("https://github.com/exercism/test_track/blob/master/docs/TEST_TOPIC.md")
  end

  def test_method_delegated_to_trackler_track
    @trackler_track.stubs(:exists?).returns(true)
    assert_equal @track.exists?, true
  end
end
