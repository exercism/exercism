require_relative '../../test_helper'
require_relative '../../tracks_helper'
require_relative '../../../app/presenters/tracks'

class PresentersTracksTest < Minitest::Test
  def setup
    @tracks = ExercismWeb::Presenters::Tracks
  end

  def test_stuff
    active = ["Clojure", "CoffeeScript", "C++", "C#", "Elixir", "Erlang", "F#", "Go", "Haskell", "Java", "JavaScript", "Common Lisp", "Lua", "Objective-C", "OCaml", "Perl 5", "PL/SQL", "Python", "Ruby", "Scala", "Swift"]
    upcoming = ["Groovy", "Nimrod", "Perl 6", "PHP", "Rust", "VB.NET"]
    planned = ["Assembly", "Bash", "C", "D", "ECMAScript", "Windows PowerShell", "Mathematical Proofs", "R", "Standard ML"]

    assert_equal active, @tracks.active.map(&:language)
    assert_equal upcoming, @tracks.upcoming.map(&:language)
    assert_equal planned, @tracks.planned.map(&:language)
  end

  def test_repository
    languages = @tracks.load_tracks.map { |track| track.slug}
    languages.each do |l|
      assert_equal "https://github.com/exercism/x#{l}", @tracks.repo_url(l)
    end
  end
end
