import java.util.{Calendar, GregorianCalendar}

case class Gigasecond(initial: Calendar) {
  val date = {
    val copy = initial.clone.asInstanceOf[Calendar]
    copy.add(Calendar.SECOND, 1000000000)
    copy.set(Calendar.SECOND, 0)
    copy.set(Calendar.MINUTE, 0)
    copy.set(Calendar.HOUR, 0)
    copy
  }
}
