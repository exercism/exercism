Code.load_file("frequency.exs")
ExUnit.start

# Your code should contain a frequency(texts, workers) function which accepts a
# list of texts and the number of workers to use in parallel.

defmodule FrequencyTest do
  use ExUnit.Case, async: true
 
  # Poem by Friedrich Schiller. The corresponding music is the European Anthem.
  @ode_an_die_freude """
  Freude schöner Götterfunken
  Tochter aus Elysium,
  Wir betreten feuertrunken,
  Himmlische, dein Heiligtum!
  Deine Zauber binden wieder
  Was die Mode streng geteilt;
  Alle Menschen werden Brüder,
  Wo dein sanfter Flügel weilt.
  """

  # Dutch national anthem
  @wilhelmus """
  Wilhelmus van Nassouwe
  ben ik, van Duitsen bloed,
  den vaderland getrouwe
  blijf ik tot in den dood.
  Een Prinse van Oranje
  ben ik, vrij, onverveerd,
  den Koning van Hispanje
  heb ik altijd geëerd.
  """

  # American national anthem
  @star_spangled_banner """
  O say can you see by the dawn's early light,
  What so proudly we hailed at the twilight's last gleaming,
  Whose broad stripes and bright stars through the perilous fight,
  O'er the ramparts we watched, were so gallantly streaming?
  And the rockets' red glare, the bombs bursting in air,
  Gave proof through the night that our flag was still there;
  O say does that star-spangled banner yet wave,
  O'er the land of the free and the home of the brave?
  """

  # Returns the frequencies in a sorted list. This means it doesn't matter if
  # your frequency() function returns a list of pairs or some dictionary, the
  # testing code will handle it.
  defp freq(texts, workers // 4) do
    Frequency.frequency(texts, workers) |> Enum.sort()
  end

  test "no texts mean no letters" do
    assert freq([]) == []
  end

  test "one letter" do
    assert freq(["a"]) == [{"a", 1}]
  end

  test "case insensitivity" do
    assert freq(["aA"]) == [{"a", 2}]
  end

  test "many empty texts still mean no letters" do
    assert freq(List.duplicate("  ", 10000)) == []
  end
  
  test "many times the same text gives a predictable result" do
    assert freq(List.duplicate("abc", 1000))
         == [{"a", 1000}, {"b", 1000}, {"c", 1000}]
  end

  test "punctuation doesn't count" do
    assert freq([@ode_an_die_freude])[","] == nil
  end

  test "numbers don't count" do
    assert freq(["Testing, 1, 2, 3"])["1"] == nil
  end
  
  test "all three anthems, together, 1 worker" do
    freqs = freq([@ode_an_die_freude, @wilhelmus, @star_spangled_banner], 1)
    assert freqs["a"] == 49
    assert freqs["t"] == 56
    assert freqs["ü"] == 2
  end
  
  test "all three anthems, together, 4 workers" do
    freqs = freq([@ode_an_die_freude, @wilhelmus, @star_spangled_banner], 4)
    assert freqs["a"] == 49
    assert freqs["t"] == 56
    assert freqs["ü"] == 2
  end
end
