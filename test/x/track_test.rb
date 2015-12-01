require_relative '../test_helper'
require_relative '../x_helper'

module X
  class TrackTest < Minitest::Test
    def test_tracks
      expected =  ["assembly", "bash", "c", "clojure", "coffeescript", "coldfusion", "cpp", "csharp", "dlang", "ecmascript", "elisp", "elixir", "erlang", "fsharp", "go", "groovy", "haskell", "haxe", "java", "javascript", "lfe", "lisp", "lua", "nimrod", "objective-c", "ocaml", "perl5", "perl6", "php", "plsql", "pony", "powershell", "proofs", "python", "r", "racket", "ruby", "rust", "scala", "scheme", "sml", "swift", "tcl", "vbnet"]
      assert_equal expected, Track.all.map(&:id).sort
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
