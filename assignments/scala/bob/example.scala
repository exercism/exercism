class Bob {
  def hey(statement: String): String = statement match {
    case Shouting() => "Woah, chill out!"
    case Question() => "Sure."
    case Silence() => "Fine. Be that way!"
    case _ => "Whatever."
  }

  case object Shouting {
    def unapply(statement: String) =
      hasLetter(statement) && isOnlyUppercase(statement)

    private def hasLetter(s: String) = s.matches(".*[A-Z].*")

    private def isOnlyUppercase(s: String) = s == s.toUpperCase
  }

  case object Question {
    def unapply(statement: String) = statement.endsWith("?")
  }

  case object Silence {
    def unapply(statement: String) = statement.trim.isEmpty
  }
}
