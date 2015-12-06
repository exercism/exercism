require_relative '../test_helper'
require_relative '../x_helper'

module X
  class LanguageTest < Minitest::Test
    def test_language_name

      docs = {"about" => "", "installation" => "", "tests" => "", "learning" => "", "resources" => ""}
      all_tracks = [Track.new({"id" => "cpp", "language" => "C++", "problems" => [], "docs" => docs, "repository" => ""})]

      Track.stub :all, all_tracks do
        assert_equal 'C++', Language.of('cpp')
      end
    end

    def test_caching
      tracks = { "cpp" => "C++" }

      Language.tracks = tracks
      Language.of("python")

      assert_equal tracks.merge({ "python" => "Python" }), Language.tracks
    end
  end
end
