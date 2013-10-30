import org.scalatest._

class TwoTest extends FunSuite with Matchers {
  test ("two") {
    Two.value should be (2)
  }
}
