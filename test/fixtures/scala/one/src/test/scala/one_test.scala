import org.scalatest._

class OneTest extends FunSuite with Matchers {
  test ("one") {
    One.value should be (1)
  }
}
