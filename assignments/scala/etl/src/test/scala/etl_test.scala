import org.scalatest._

class TransformTest extends FunSuite with Matchers {
  test ("transform one value") {
    val old = Map(1 -> Seq("WORLD"))

    ETL.transform(old) should be (Map("world" -> 1))
  }

  test ("transform more values") {
    pending
    val old = Map(1 -> Seq("WORLD", "GSCHOOLERS"))
    val expected = Map("world" -> 1, "gschoolers" -> 1)

    ETL.transform(old) should be (expected)
  }

  test ("more keys") {
    pending
    val old = Map(1 -> Seq("APPLE", "ARTICHOKE"), 2 -> Seq("BOAT", "BALLERINA"))
    val expected = Map("apple" -> 1, "artichoke" -> 1, "boat" -> 2, "ballerina" -> 2)
    ETL.transform(old) should be (expected)
  }

  test ("full dataset") {
    pending
    val old = Map(
      1 -> Seq("A", "E", "I", "O", "U", "L", "N", "R", "S", "T"),
      2 -> Seq("D", "G"),
      3 -> Seq("B", "C", "M", "P"),
      4 -> Seq("F", "H", "V", "W", "Y"),
      5 -> Seq("K"),
      8 -> Seq("J", "X"),
      10 -> Seq("Q", "Z")
    )
    val expected = Map(
      "a" -> 1, "b" -> 3, "c" -> 3, "d" -> 2, "e" -> 1,
      "f" -> 4, "g" -> 2, "h" -> 4, "i" -> 1, "j" -> 8,
      "k" -> 5, "l" -> 1, "m" -> 3, "n" -> 1, "o" -> 1,
      "p" -> 3, "q" -> 10, "r" -> 1, "s" -> 1, "t" -> 1,
      "u" -> 1, "v" -> 4, "w" -> 4, "x" -> 8, "y" -> 4,
      "z" -> 10
    )
    ETL.transform(old) should be (expected)
  }
}
