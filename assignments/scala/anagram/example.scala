class Anagram(word: String) {
  def matches(anagrams: Seq[String]) =
    anagrams.filter(doesMatch).filterNot(isIdentical)

  private def doesMatch(anagram: String) =
    anagram.toLowerCase.sorted == word.toLowerCase.sorted

  private def isIdentical(anagram: String) =
    anagram.toLowerCase == word.toLowerCase
}
