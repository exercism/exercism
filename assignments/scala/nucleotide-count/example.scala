class DNA(strand: String) {
  strand.foreach(validate)

  def count(nucleotide: Char) = {
    validateCountable(nucleotide)
    strand.count(_ == nucleotide)
  }

  def nucleotideCounts = Map(
    'A' -> count('A'),
    'T' -> count('T'),
    'C' -> count('C'),
    'G' -> count('G')
  )

  private def validate(nucleotide: Char) =
    if (!isNucleotide(nucleotide))
      throw new IllegalArgumentException

  private def validateCountable(nucleotide: Char) =
    if (!isCountable(nucleotide))
      throw new IllegalArgumentException

  private def isCountable(nucleotide: Char) =
    DNA.countable.contains(nucleotide)

  private def isNucleotide(nucleotide: Char) =
    DNA.nucleotides.contains(nucleotide)
}

object DNA {
  val nucleotides = "ATCG"
  val countable = nucleotides + 'U'
}
