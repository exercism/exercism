import org.scalatest._

class WordCountSpecs extends FlatSpec with Matchers {
  it should "count one word" in {
    val phrase = new Phrase("word")
    phrase.wordCount should be (Map("word" -> 1))
  }

  it should "count one of each" in {
    pending
    val phrase = new Phrase("one of each")
    val counts = Map("one" -> 1, "of" -> 1, "each" -> 1)
    phrase.wordCount should be (counts)
  }

  it should "count multiple occurrences" in {
    pending
    val phrase = new Phrase("one fish two fish red fish blue fish")
    val counts = Map("one" -> 1, "fish" -> 4, "two" -> 1, "red" -> 1, "blue" -> 1)
    phrase.wordCount should be (counts)
  }

  it should "count everything just once" in {
    pending
    val phrase = new Phrase("all the kings horses and all the kings men")
    phrase.wordCount
    val counts = Map(
      "all" -> 2, "the" -> 2, "kings" -> 2, "horses" -> 1, "and" -> 1, "men" -> 1
    )
    phrase.wordCount should be (counts)
  }

  it should "ignore punctuation" in {
    pending
    val phrase = new Phrase("car : carpet as java : javascript!!&@$%^&")
    val counts = Map(
      "car" -> 1, "carpet" -> 1, "as" -> 1, "java" -> 1, "javascript" -> 1
    )
    phrase.wordCount should be (counts)
  }

  it should "handle cramped lists" in {
    pending
    val phrase = new Phrase("one,two,three")
    phrase.wordCount should be (Map("one" -> 1, "two" -> 1, "three" -> 1))
  }

  it should "include numbers" in {
    pending
    val phrase = new Phrase("testing, 1, 2 testing")
    val counts = Map("testing" -> 2, "1" -> 1, "2" -> 1)
    phrase.wordCount should be (counts)
  }

  it should "normalize case" in {
    pending
    val phrase = new Phrase("go Go GO")
    val counts = Map("go" -> 3)
    phrase.wordCount should be (counts)
  }

  it should "allow apostrophes" in {
    pending
    val phrase = new Phrase("First: don't laugh. Then: don't cry.")
    val counts =
      Map("first" -> 1, "don't" -> 2, "laugh" -> 1, "then" -> 1, "cry" -> 1)
    phrase.wordCount should be (counts)
  }
}
