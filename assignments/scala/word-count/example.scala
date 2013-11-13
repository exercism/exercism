class Phrase(phrase: String) {
  def wordCount = groupedWords.mapValues(_.size)

  private def groupedWords = words.groupBy(w => w)

  private def words = withoutPunctuation.split("\\s+")

  private def withoutPunctuation = phrase.toLowerCase.replaceAll("[^\\w']", " ")
}
