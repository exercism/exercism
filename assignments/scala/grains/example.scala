object Grains {
  def square(x: Int): BigInt = BigInt(2).pow(x-1)
  def total = 1.to(64).map(square).sum
}
