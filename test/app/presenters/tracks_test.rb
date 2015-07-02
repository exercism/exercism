require_relative '../../test_helper'
require 'app/presenters/tracks'

class PresentersTracksTest < Minitest::Test
  def test_stuff
    tracks = ExercismWeb::Presenters::Tracks
    active = ["Clojure", "CoffeeScript", "C++", "C#", "Elixir", "Erlang", "F#", "Go", "Haskell", "Java", "JavaScript", "Common Lisp", "Lua", "Objective-C", "OCaml", "Perl 5", "PL/SQL", "Python", "Ruby", "Scala", "Swift"]
    upcoming = ["Groovy", "Nimrod", "Perl 6", "PHP", "Rust", "VB.NET"]
    planned = ["Assembly", "Bash", "C", "D", "ECMAScript", "Windows PowerShell", "Mathematical Proofs", "R", "Standard ML"]

    assert_equal active, active
    assert_equal upcoming, upcoming
    assert_equal planned, planned
  end
end
