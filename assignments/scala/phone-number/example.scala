class PhoneNumber(rawNumber: String) {
  def number = cleanedNumber match {
    case validationRegex(num) => num
    case _ => "0000000000"
  }

  def areaCode = number.substring(0, 3)

  def exchangeCode = number.substring(3, 6)

  def subscriberNumber = number.substring(6, 10)

  override def toString = s"($areaCode) $exchangeCode-$subscriberNumber"

  private val validationRegex = """^1?(\d{10})$""".r

  private val cleanedNumber = rawNumber.replaceAll("""[^\d]""", "")
}
