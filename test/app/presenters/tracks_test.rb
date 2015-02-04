require_relative '../../test_helper'
require 'app/presenters/tracks'

class PresentersTracksTest < Minitest::Test
  def test_stuff
    data = JSON.parse(File.read("./test/fixtures/tracks.json"))["tracks"]
    tracks = ExercismWeb::Presenters::Tracks.new data
    active = ["Clojure", "CoffeeScript", "C++", "C#", "Elixir", "Erlang", "F#", "Go", "Haskell", "Java", "JavaScript", "Common Lisp", "Lua", "Objective-C", "OCaml", "Perl 5", "PL/SQL", "Python", "Ruby", "Scala", "Swift"]
    upcoming = ["Groovy", "Nimrod", "Perl 6", "PHP", "Rust", "VB.NET"]
    planned = ["Assembly", "Bash", "C", "D", "ECMAScript", "Windows PowerShell", "Mathematical Proofs", "R", "Standard ML"]

    assert_equal active, tracks.active
    assert_equal upcoming, tracks.upcoming
    assert_equal planned, tracks.planned
  end
end

