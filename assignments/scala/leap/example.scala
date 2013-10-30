case class Year(year: Int) {
  lazy val isLeap: Boolean = divisibleBy(4) && (divisibleBy(400) || !divisibleBy(100))

  private def divisibleBy(i: Int) = year % i == 0
}
