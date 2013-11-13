import org.scalatest._

class AnagramSpecs extends FlatSpec with Matchers {
  it should "detect no matches" in {
    val detector = new Anagram("diaper")
    val anagrams = detector.matches(Seq("hello", "world", "zombies", "pants"))
    anagrams should equal (Seq())
  }

  it should "detect simple anagrams" in {
    pending
    val detector = new Anagram("ant")
    val anagrams = detector.matches(Seq("tan", "stand", "at"))
    anagrams should equal (Seq("tan"))
  }

  it should "detect multiple anagrams" in {
    pending
    val detector = new Anagram("master")
    val anagrams = detector.matches(Seq("stream", "pigeon", "maters"))
    anagrams.sorted should equal (Seq("maters", "stream"))
  }

  it should "not confuse different duplicates" in {
    pending
    val detector = new Anagram("galea")
    val anagrams = detector.matches(Seq("eagle"))
    anagrams should equal (Seq())
  }

  it should "not include identical words" in {
    pending
    val detector = new Anagram("corn")
    val anagrams = detector.matches(Seq(
      "corn", "dark", "Corn", "rank", "CORN", "cron", "park"
    ))
    anagrams should equal (Seq("cron"))
  }

  it should "elimitate anagrams with same checksum" in {
    pending
    val detector = new Anagram("mass")
    detector.matches(Seq("last")) should equal (Seq())
  }

  it should "eliminate anagrams subsets" in {
    pending
    val detector = new Anagram("good")
    detector.matches(Seq("dog", "goody")) should equal (Seq())
  }

  it should "detect anagrams" in {
    pending
    val detector = new Anagram("listen")
    val anagrams = detector.matches(Seq("enlists", "google", "inlets", "banana"))
    anagrams should equal (Seq("inlets"))
  }

  it should "detect more anagrams" in {
    pending
    val detector = new Anagram("allergy")
    val anagrams = detector.matches(Seq(
      "gallery", "ballerina", "regally", "clergy", "largely", "leading"
    ))
    anagrams.sorted should equal (Seq("gallery", "largely", "regally"))
  }

  it should "treat anagrams as case insensitive" in {
    pending
    val detector = new Anagram("Orchestra")
    val anagrams = detector.matches(Seq(
      "cashregister", "Carthorse", "radishes"
    ))
    anagrams should equal(Seq("Carthorse"))
  }
}
