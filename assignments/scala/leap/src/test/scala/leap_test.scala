import org.scalatest._

class LeapTest extends FunSuite {
  test ("vanilla leap year") {
    assert(Year(1996).isLeap)
  }

  test ("any old year") {
    pending
    assert(!Year(1997).isLeap)
  }

  test ("century") {
    pending
    assert(!Year(1900).isLeap)
  }

  test ("exceptional century") {
    pending
    assert(Year(2000).isLeap)
  }
}
