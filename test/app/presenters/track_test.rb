require_relative '../../test_helper'
require_relative '../../../app/presenters/track'
require_relative '../../api_helper'
require 'mocha/setup'

class PresentersTrackTest < Minitest::Test
  def setup
    @trackler_track = Object.new
    @trackler_track.stubs(:repository).returns("https://github.com/exercism/test_track")
    @trackler_track.stubs(:doc_format).returns("md")

    trackler_tracks = Object.new
    trackler_tracks.stubs(:[]).returns(@trackler_track)

    Trackler.stubs(:tracks).returns(trackler_tracks)
  end

  def test_docs_with_trackler_content
    @trackler_track.stubs(:docs).returns(OpenStruct.new(about: "Track-specific content from Trackler"))
    topic_doc = ExercismWeb::Presenters::Track.new("test_track").docs["about"]

    assert topic_doc.include? "Track-specific content from Trackler"
    assert topic_doc.include? "Help us explain this better!"
    assert topic_doc.include? "File a GitHub issue at https://github.com/exercism/test_track"
    assert topic_doc.include? "https://github.com/exercism/test_track/blob/master/docs/ABOUT.md"
  end

  def test_docs_without_trackler_content
    @trackler_track.stubs(:docs).returns(OpenStruct.new(about: ""))
    topic_doc = ExercismWeb::Presenters::Track.new("test_track").docs["about"]

    assert topic_doc.include? "We're missing a short introduction about the language."
    assert topic_doc.include? "https://github.com/exercism/test_track"
  end

  def test_method_delegated_to_trackler_track
    @trackler_track.stubs(:exists?).returns(true)
    assert_equal ExercismWeb::Presenters::Track.new("test_track").exists?, true
  end
end
