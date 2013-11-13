import java.util.{Calendar, GregorianCalendar}

case class Meetup(month: Int, year: Int) {
  private val thirteenth = new GregorianCalendar(year, month - 1, 13)
  private val first = new GregorianCalendar(year, month - 1, 1)
  private val nextMonth = first.addMonths(1)

  def teenth(day: Int): Calendar = thirteenth.next(day)
  def first(day: Int): Calendar = first.next(day)
  def second(day: Int): Calendar = first(day).addDays(7)
  def third(day: Int): Calendar = second(day).addDays(7)
  def fourth(day: Int): Calendar = third(day).addDays(7)
  def last(day: Int): Calendar = nextMonth.next(day).addDays(-7)

  implicit class ImmutableCalendar(calendar: Calendar) {
    def next(dayOfWeek: Int): Calendar = addDays(daysUntil(dayOfWeek))

    def addDays(count: Int): Calendar = copyAnd(_.add(Calendar.DAY_OF_YEAR, count))

    def addMonths(count: Int): Calendar = copyAnd(_.add(Calendar.MONTH, count))

    def daysUntil(dayOfWeek: Int): Int = (Meetup.Sat - this.dayOfWeek + dayOfWeek) % 7

    def dayOfWeek: Int = calendar.get(Calendar.DAY_OF_WEEK)

    private def copy: Calendar = calendar.clone.asInstanceOf[Calendar]

    private def copyAnd(f: Calendar => Unit) = {
      val c = copy
      f(c)
      c
    }
  }
}

object Meetup {
  val Mon = Calendar.MONDAY
  val Tue = Calendar.TUESDAY
  val Wed = Calendar.WEDNESDAY
  val Thu = Calendar.THURSDAY
  val Fri = Calendar.FRIDAY
  val Sat = Calendar.SATURDAY
  val Sun = Calendar.SUNDAY
}
