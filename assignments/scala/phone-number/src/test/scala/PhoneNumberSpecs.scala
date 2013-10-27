import org.scalatest._

class PhoneNumberSpecs extends FlatSpec with Matchers {
  it should "clean the number" in {
    val number = new PhoneNumber("(123) 456-7890").number
    number should be ("1234567890")
  }

  it should "clean numbers with dots" in {
    pending
    val number = new PhoneNumber("123.456.7890").number
    number should be ("1234567890")
  }

  it should "be valid when 11 digits and first is 1" in {
    pending
    val number = new PhoneNumber("11234567890").number
    number should be ("1234567890")
  }

  it should "be invalid when 11 digits" in {
    pending
    val number = new PhoneNumber("21234567890").number
    number should be ("0000000000")
  }

  it should "be invalid when 9 digits" in {
    pending
    val number = new PhoneNumber("123456789").number
    number should be ("0000000000")
  }

  it should "give the area code" in {
    pending
    val number = new PhoneNumber("1234567890")
    number.areaCode should be("123")
  }

  it should "format the number" in {
    pending
    val number = new PhoneNumber("1234567890")
    number.toString should be ("(123) 456-7890")
  }

  it should "format full us phone numbers" in {
    pending
    val number = new PhoneNumber("11234567890")
    number.toString should be ("(123) 456-7890")
  }
}
