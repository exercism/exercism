require_relative '../../test_helper'
require 'app/presenters/tracks'

class PresentersTracksTest < Minitest::Test
  def test_stuff
    tracks = ExercismWeb::Presenters::Tracks
    active = ["Clojure", "CoffeeScript", "C++", "C#", "Elixir", "Erlang", "F#", "Go", "Haskell", "Java", "JavaScript", "Common Lisp", "Lua", "Objective-C", "OCaml", "Perl 5", "PL/SQL", "Python", "Ruby", "Scala", "Swift"]
    upcoming = ["Groovy", "Nimrod", "Perl 6", "PHP", "Rust", "VB.NET"]
    planned = ["Assembly", "Bash", "C", "D", "ECMAScript", "Windows PowerShell", "Mathematical Proofs", "R", "Standard ML"]
    ids = ["assembly", "bash", "c", "clojure", "coffeescript", "cpp", "csharp", "dlang", "ecmascript", "elixir", "erlang", "fsharp", "go", "groovy", "haskell", "java", "javascript", "lisp", "lua", "nimrod", "objective-c", "ocaml", "perl5", "perl6", "php", "plsql", "powershell", "proofs", "python", "r", "ruby", "rust", "scala", "sml", "swift", "vbnet"]

    assert_equal active, tracks.active.map(&:language)
    assert_equal upcoming, tracks.upcoming.map(&:language)
    assert_equal planned, tracks.planned.map(&:language)
    assert_equal ids, tracks.ids
  end
end
