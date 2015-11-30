require_relative '../test_helper'
require_relative '../x_helper'

module X
  class TrackTest < Minitest::Test
    def test_tracks
      f= './test/fixtures/xapi_v3_tracks.json'
      Xapi.stub(:get, [200, File.read(f)]) do
        expected = %w(animal fake fruit jewels)
        assert_equal expected, Track.all.map(&:id).sort
      end
    end

    def test_track
      f = './test/fixtures/xapi_v3_track_fake.json'
      Xapi.stub(:get, [200, File.read(f)]) do
        track = Track.find("fake")

        assert_equal "Fake", track.language
        assert_equal "Language Information", track.docs.about.split("\n").first
        assert_equal "Hello World", track.problems.first.name
      end
    end
  end
end
