import org.scalatest._
import java.util.GregorianCalendar

class MeetupTest extends FunSuite with Matchers {
  //Note: Java uses 0-indexed months for GregorianCalendar
  test ("monteenth of may 2013") {
    Meetup(5, 2013).teenth(Meetup.Mon) should be (new GregorianCalendar(2013, 4, 13))
  }

  test ("monteenth of august 2013") {
    pending
    Meetup(8, 2013).teenth(Meetup.Mon) should be (new GregorianCalendar(2013, 7, 19))
  }

  test ("monteenth of september 2013") {
    pending
    Meetup(9, 2013).teenth(Meetup.Mon) should be (new GregorianCalendar(2013, 8, 16))
  }

  test ("tuesteenth of march 2013") {
    pending
    Meetup(3, 2013).teenth(Meetup.Tue) should be (new GregorianCalendar(2013, 2, 19))
  }

  test ("tuesteenth of april 2013") {
    pending
    Meetup(4, 2013).teenth(Meetup.Tue) should be (new GregorianCalendar(2013, 3, 16))
  }

  test ("tuesteenth of august 2013") {
    pending
    Meetup(8, 2013).teenth(Meetup.Tue) should be (new GregorianCalendar(2013, 7, 13))
  }

  test ("wednesteenth of january 2013") {
    pending
    Meetup(1, 2013).teenth(Meetup.Wed) should be (new GregorianCalendar(2013, 0, 16))
  }

  test ("wednesteenth of february 2013") {
    pending
    Meetup(2, 2013).teenth(Meetup.Wed) should be (new GregorianCalendar(2013, 1, 13))
  }

  test ("wednesteenth of june 2013") {
    pending
    Meetup(6, 2013).teenth(Meetup.Wed) should be (new GregorianCalendar(2013, 5, 19))
  }

  test ("thursteenth of may 2013") {
    pending
    Meetup(5, 2013).teenth(Meetup.Thu) should be (new GregorianCalendar(2013, 4, 16))
  }

  test ("thursteenth of june 2013") {
    pending
    Meetup(6, 2013).teenth(Meetup.Thu) should be (new GregorianCalendar(2013, 5, 13))
  }

  test ("thursteenth of september 2013") {
    pending
    Meetup(9, 2013).teenth(Meetup.Thu) should be (new GregorianCalendar(2013, 8, 19))
  }

  test ("friteenth of april 2013") {
    pending
    Meetup(4, 2013).teenth(Meetup.Fri) should be (new GregorianCalendar(2013, 3, 19))
  }

  test ("friteenth of august 2013") {
    pending
    Meetup(8, 2013).teenth(Meetup.Fri) should be (new GregorianCalendar(2013, 7, 16))
  }

  test ("friteenth of september 2013") {
    pending
    Meetup(9, 2013).teenth(Meetup.Fri) should be (new GregorianCalendar(2013, 8, 13))
  }

  test ("saturteenth of february 2013") {
    pending
    Meetup(2, 2013).teenth(Meetup.Sat) should be (new GregorianCalendar(2013, 1, 16))
  }

  test ("saturteenth of april 2013") {
    pending
    Meetup(4, 2013).teenth(Meetup.Sat) should be (new GregorianCalendar(2013, 3, 13))
  }

  test ("saturteenth of october 2013") {
    pending
    Meetup(10, 2013).teenth(Meetup.Sat) should be (new GregorianCalendar(2013, 9, 19))
  }

  test ("sunteenth of map 2013") {
    pending
    Meetup(5, 2013).teenth(Meetup.Sun) should be (new GregorianCalendar(2013, 4, 19))
  }

  test ("sunteenth of june 2013") {
    pending
    Meetup(6, 2013).teenth(Meetup.Sun) should be (new GregorianCalendar(2013, 5, 16))
  }

  test ("sunteenth of october 2013") {
    pending
    Meetup(10, 2013).teenth(Meetup.Sun) should be (new GregorianCalendar(2013, 9, 13))
  }

  test ("first monday of march 2013") {
    pending
    Meetup(3, 2013).first(Meetup.Mon) should be (new GregorianCalendar(2013, 2, 4))
  }

  test ("first monday of april 2013") {
    pending
    Meetup(4, 2013).first(Meetup.Mon) should be (new GregorianCalendar(2013, 3, 1))
  }

  test ("first tuesday of may 2013") {
    pending
    Meetup(5, 2013).first(Meetup.Tue) should be (new GregorianCalendar(2013, 4, 7))
  }

  test ("first tuesday of june 2013") {
    pending
    Meetup(6, 2013).first(Meetup.Tue) should be (new GregorianCalendar(2013, 5, 4))
  }

  test ("first wednesday of july 2013") {
    pending
    Meetup(7, 2013).first(Meetup.Wed) should be (new GregorianCalendar(2013, 6, 3))
  }

  test ("first wednesday of august 2013") {
    pending
    Meetup(8, 2013).first(Meetup.Wed) should be (new GregorianCalendar(2013, 7, 7))
  }

  test ("first thursday of september 2013") {
    pending
    Meetup(9, 2013).first(Meetup.Thu) should be (new GregorianCalendar(2013, 8, 5))
  }

  test ("first thursday of october 2013") {
    pending
    Meetup(10, 2013).first(Meetup.Thu) should be (new GregorianCalendar(2013, 9, 3))
  }

  test ("first friday of november 2013") {
    pending
    Meetup(11, 2013).first(Meetup.Fri) should be (new GregorianCalendar(2013, 10, 1))
  }

  test ("first friday of december 2013") {
    pending
    Meetup(12, 2013).first(Meetup.Fri) should be (new GregorianCalendar(2013, 11, 6))
  }

  test ("first saturday of january 2013") {
    pending
    Meetup(1, 2013).first(Meetup.Sat) should be (new GregorianCalendar(2013, 0, 5))
  }

  test ("first saturday of february 2013") {
    pending
    Meetup(2, 2013).first(Meetup.Sat) should be (new GregorianCalendar(2013, 1, 2))
  }

  test ("first sunday of march 2013") {
    pending
    Meetup(3, 2013).first(Meetup.Sun) should be (new GregorianCalendar(2013, 2, 3))
  }

  test ("first sunday of april 2013") {
    pending
    Meetup(4, 2013).first(Meetup.Sun) should be (new GregorianCalendar(2013, 3, 7))
  }

  test ("second monday of march 2013") {
    pending
    Meetup(3, 2013).second(Meetup.Mon) should be (new GregorianCalendar(2013, 2, 11))
  }

  test ("second monday of april 2013") {
    pending
    Meetup(4, 2013).second(Meetup.Mon) should be (new GregorianCalendar(2013, 3, 8))
  }

  test ("second tuesday of may 2013") {
    pending
    Meetup(5, 2013).second(Meetup.Tue) should be (new GregorianCalendar(2013, 4, 14))
  }

  test ("second tuesday of june 2013") {
    pending
    Meetup(6, 2013).second(Meetup.Tue) should be (new GregorianCalendar(2013, 5, 11))
  }

  test ("second wednesday of july 2013") {
    pending
    Meetup(7, 2013).second(Meetup.Wed) should be (new GregorianCalendar(2013, 6, 10))
  }

  test ("second wednesday of august 2013") {
    pending
    Meetup(8, 2013).second(Meetup.Wed) should be (new GregorianCalendar(2013, 7, 14))
  }

  test ("second thursday of september 2013") {
    pending
    Meetup(9, 2013).second(Meetup.Thu) should be (new GregorianCalendar(2013, 8, 12))
  }

  test ("second thursday of october 2013") {
    pending
    Meetup(10, 2013).second(Meetup.Thu) should be (new GregorianCalendar(2013, 9, 10))
  }

  test ("second friday of november 2013") {
    pending
    Meetup(11, 2013).second(Meetup.Fri) should be (new GregorianCalendar(2013, 10, 8))
  }

  test ("second friday of december 2013") {
    pending
    Meetup(12, 2013).second(Meetup.Fri) should be (new GregorianCalendar(2013, 11, 13))
  }

  test ("second saturday of january 2013") {
    pending
    Meetup(1, 2013).second(Meetup.Sat) should be (new GregorianCalendar(2013, 0, 12))
  }

  test ("second saturday of february 2013") {
    pending
    Meetup(2, 2013).second(Meetup.Sat) should be (new GregorianCalendar(2013, 1, 9))
  }

  test ("second sunday of march 2013") {
    pending
    Meetup(3, 2013).second(Meetup.Sun) should be (new GregorianCalendar(2013, 2, 10))
  }

  test ("second sunday of april 2013") {
    pending
    Meetup(4, 2013).second(Meetup.Sun) should be (new GregorianCalendar(2013, 3, 14))
  }

  test ("third monday of march 2013") {
    pending
    Meetup(3, 2013).third(Meetup.Mon) should be (new GregorianCalendar(2013, 2, 18))
  }

  test ("third monday of april 2013") {
    pending
    Meetup(4, 2013).third(Meetup.Mon) should be (new GregorianCalendar(2013, 3, 15))
  }

  test ("third tuesday of may 2013") {
    pending
    Meetup(5, 2013).third(Meetup.Tue) should be (new GregorianCalendar(2013, 4, 21))
  }

  test ("third tuesday of june 2013") {
    pending
    Meetup(6, 2013).third(Meetup.Tue) should be (new GregorianCalendar(2013, 5, 18))
  }

  test ("third wednesday of july 2013") {
    pending
    Meetup(7, 2013).third(Meetup.Wed) should be (new GregorianCalendar(2013, 6, 17))
  }

  test ("third wednesday of august 2013") {
    pending
    Meetup(8, 2013).third(Meetup.Wed) should be (new GregorianCalendar(2013, 7, 21))
  }

  test ("third thursday of september 2013") {
    pending
    Meetup(9, 2013).third(Meetup.Thu) should be (new GregorianCalendar(2013, 8, 19))
  }

  test ("third thursday of october 2013") {
    pending
    Meetup(10, 2013).third(Meetup.Thu) should be (new GregorianCalendar(2013, 9, 17))
  }

  test ("third friday of november 2013") {
    pending
    Meetup(11, 2013).third(Meetup.Fri) should be (new GregorianCalendar(2013, 10, 15))
  }

  test ("third friday of december 2013") {
    pending
    Meetup(12, 2013).third(Meetup.Fri) should be (new GregorianCalendar(2013, 11, 20))
  }

  test ("third saturday of january 2013") {
    pending
    Meetup(1, 2013).third(Meetup.Sat) should be (new GregorianCalendar(2013, 0, 19))
  }

  test ("third saturday of february 2013") {
    pending
    Meetup(2, 2013).third(Meetup.Sat) should be (new GregorianCalendar(2013, 1, 16))
  }

  test ("third sunday of march 2013") {
    pending
    Meetup(3, 2013).third(Meetup.Sun) should be (new GregorianCalendar(2013, 2, 17))
  }

  test ("third sunday of april 2013") {
    pending
    Meetup(4, 2013).third(Meetup.Sun) should be (new GregorianCalendar(2013, 3, 21))
  }

  test ("fourth monday of march 2013") {
    pending
    Meetup(3, 2013).fourth(Meetup.Mon) should be (new GregorianCalendar(2013, 2, 25))
  }

  test ("fourth monday of april 2013") {
    pending
    Meetup(4, 2013).fourth(Meetup.Mon) should be (new GregorianCalendar(2013, 3, 22))
  }

  test ("fourth tuesday of may 2013") {
    pending
    Meetup(5, 2013).fourth(Meetup.Tue) should be (new GregorianCalendar(2013, 4, 28))
  }

  test ("fourth tuesday of june 2013") {
    pending
    Meetup(6, 2013).fourth(Meetup.Tue) should be (new GregorianCalendar(2013, 5, 25))
  }

  test ("fourth wednesday of july 2013") {
    pending
    Meetup(7, 2013).fourth(Meetup.Wed) should be (new GregorianCalendar(2013, 6, 24))
  }

  test ("fourth wednesday of august 2013") {
    pending
    Meetup(8, 2013).fourth(Meetup.Wed) should be (new GregorianCalendar(2013, 7, 28))
  }

  test ("fourth thursday of september 2013") {
    pending
    Meetup(9, 2013).fourth(Meetup.Thu) should be (new GregorianCalendar(2013, 8, 26))
  }

  test ("fourth thursday of october 2013") {
    pending
    Meetup(10, 2013).fourth(Meetup.Thu) should be (new GregorianCalendar(2013, 9, 24))
  }

  test ("fourth friday of november 2013") {
    pending
    Meetup(11, 2013).fourth(Meetup.Fri) should be (new GregorianCalendar(2013, 10, 22))
  }

  test ("fourth friday of december 2013") {
    pending
    Meetup(12, 2013).fourth(Meetup.Fri) should be (new GregorianCalendar(2013, 11, 27))
  }

  test ("fourth saturday of january 2013") {
    pending
    Meetup(1, 2013).fourth(Meetup.Sat) should be (new GregorianCalendar(2013, 0, 26))
  }

  test ("fourth saturday of february 2013") {
    pending
    Meetup(2, 2013).fourth(Meetup.Sat) should be (new GregorianCalendar(2013, 1, 23))
  }

  test ("fourth sunday of march 2013") {
    pending
    Meetup(3, 2013).fourth(Meetup.Sun) should be (new GregorianCalendar(2013, 2, 24))
  }

  test ("fourth sunday of april 2013") {
    pending
    Meetup(4, 2013).fourth(Meetup.Sun) should be (new GregorianCalendar(2013, 3, 28))
  }

  test ("last monday of march 2013") {
    pending
    Meetup(3, 2013).last(Meetup.Mon) should be (new GregorianCalendar(2013, 2, 25))
  }

  test ("last monday of april 2013") {
    pending
    Meetup(4, 2013).last(Meetup.Mon) should be (new GregorianCalendar(2013, 3, 29))
  }

  test ("last tuesday of may 2013") {
    pending
    Meetup(5, 2013).last(Meetup.Tue) should be (new GregorianCalendar(2013, 4, 28))
  }

  test ("last tuesday of june 2013") {
    pending
    Meetup(6, 2013).last(Meetup.Tue) should be (new GregorianCalendar(2013, 5, 25))
  }

  test ("last wednesday of july 2013") {
    pending
    Meetup(7, 2013).last(Meetup.Wed) should be (new GregorianCalendar(2013, 6, 31))
  }

  test ("last wednesday of august 2013") {
    pending
    Meetup(8, 2013).last(Meetup.Wed) should be (new GregorianCalendar(2013, 7, 28))
  }

  test ("last thursday of september 2013") {
    pending
    Meetup(9, 2013).last(Meetup.Thu) should be (new GregorianCalendar(2013, 8, 26))
  }

  test ("last thursday of october 2013") {
    pending
    Meetup(10, 2013).last(Meetup.Thu) should be (new GregorianCalendar(2013, 9, 31))
  }

  test ("last friday of november 2013") {
    pending
    Meetup(11, 2013).last(Meetup.Fri) should be (new GregorianCalendar(2013, 10, 29))
  }

  test ("last friday of december 2013") {
    pending
    Meetup(12, 2013).last(Meetup.Fri) should be (new GregorianCalendar(2013, 11, 27))
  }

  test ("last saturday of january 2013") {
    pending
    Meetup(1, 2013).last(Meetup.Sat) should be (new GregorianCalendar(2013, 0, 26))
  }

  test ("last saturday of february 2013") {
    pending
    Meetup(2, 2013).last(Meetup.Sat) should be (new GregorianCalendar(2013, 1, 23))
  }

  test ("last sunday of march 2013") {
    pending
    Meetup(3, 2013).last(Meetup.Sun) should be (new GregorianCalendar(2013, 2, 31))
  }

  test ("last sunday of april 2013") {
    pending
    Meetup(4, 2013).last(Meetup.Sun) should be (new GregorianCalendar(2013, 3, 28))
  }
}
