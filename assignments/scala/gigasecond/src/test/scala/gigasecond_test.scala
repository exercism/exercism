import org.scalatest._
import java.util.GregorianCalendar

class GigasecondTests extends FunSuite with Matchers {
  test ("1") {
    // Note: Months are 0-indexed. 3 = April
    val gs = Gigasecond(new GregorianCalendar(2011, 3, 25))
    gs.date should be (new GregorianCalendar(2043, 0, 1))
  }

  test ("2") {
    pending
    val gs = Gigasecond(new GregorianCalendar(1977, 5, 13))
    gs.date should be (new GregorianCalendar(2009, 1, 19))
  }

  test ("3") {
    pending
    val gs = Gigasecond(new GregorianCalendar(1959, 6, 19))
    gs.date should be (new GregorianCalendar(1991, 2, 27))
  }

  test ("yourself") {
    pending
    // val yourBirthday = new GregorianCalendar(year, month-1, day)
    // val gs = Gigasecond(yourBirthday)
    // gs.date should be (GregorianCalendar(2009, 0, 31))
  }
}
