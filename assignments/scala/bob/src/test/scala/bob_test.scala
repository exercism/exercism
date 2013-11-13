import org.scalatest._

class BobSpecs extends FlatSpec with Matchers {
  def teenager = new Bob

  it should "respond to a statement" in {
    val response = teenager.hey("Tom-ay-to, tom-aaaah-to.")
    response should be ("Whatever.")
  }

  it should "respond to shouting" in {
    pending
    val response = teenager.hey("WATCH OUT!")
    response should be ("Woah, chill out!")
  }

  it should "respond to questions" in {
    pending
    val response = teenager.hey("Does this cryogenic chamber make me look fat?")
    response should be ("Sure.")
  }

  it should "allow questions to end with numbers" in {
    pending
    val response = teenager.hey("You are what, like 15?")
    response should be ("Sure.")
  }

  it should "respond to talking forcefully" in {
    pending
    val response = teenager.hey("Let's go make out behind the gym!")
    response should be ("Whatever.")
  }

  it should "allow acroynms in regular speech" in {
    pending
    val response = teenager.hey("It's OK if you don't want to go to the DMV.")
    response should be ("Whatever.")
  }

  it should "see forceful questions as shouting" in {
    pending
    val response = teenager.hey("WHAT THE HELL WERE YOU THINKING?")
    response should be ("Woah, chill out!")
  }

  it should "allow numbers when shouting" in {
    pending
    val response = teenager.hey("1, 2, 3, GO!")
    response should be ("Woah, chill out!")
  }

  it should "see only numbers as speech" in {
    pending
    val response = teenager.hey("1, 2, 3")
    response should be ("Whatever.")
  }

  it should "respond to questions with only numbers" in {
    pending
    val response = teenager.hey("4?")
    response should be ("Sure.")
  }

  it should "respond to shouting with no exclamation mark" in {
    pending
    val response = teenager.hey("I HATE YOU")
    response should be ("Woah, chill out!")
  }

  it should "respond to statements with ? in the middle" in {
    pending
    val response = teenager.hey("Ending with ? means a question.")
    response should be ("Whatever.")
  }

  it should "respond to prattling on" in {
    pending
    val response = teenager.hey("Wait! Hang on. Are you going to be OK?")
    response should be ("Sure.")
  }

  it should "respond to silence" in {
    pending
    val response = teenager.hey("")
    response should be ("Fine. Be that way!")
  }

  it should "respond to prolonged silence" in {
    pending
    val response = teenager.hey("       ")
    response should be ("Fine. Be that way!")
  }

  it should "respond to multiple line questions" in {
    pending
    val response = teenager.hey("""
Does this cryogenic chamber make me look fat?
no""")
    response should be ("Whatever.")
  }
}
