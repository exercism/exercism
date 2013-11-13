case class SpaceAge(val seconds: Long) {
  lazy val onEarth: Double = round(earthYears)
  lazy val onMercury: Double = round(mercuryYears)
  lazy val onVenus: Double = round(venusYears)
  lazy val onMars: Double = round(marsYears)
  lazy val onJupiter: Double = round(jupiterYears)
  lazy val onSaturn: Double = round(saturnYears)
  lazy val onUranus: Double = round(uranusYears)
  lazy val onNeptune: Double = round(neptuneYears)

  private val minutes = seconds.toDouble / 60
  private val hours = minutes / 60
  private val days = hours / 24
  private val earthYears = days / 365.25
  private val mercuryYears = days / 87.969
  private val venusYears = days / 224.701
  private val marsYears = days / 686.971
  private val jupiterYears = days / 4332.59
  private val saturnYears = days / 10759.22
  private val uranusYears = days / 30799.095
  private val neptuneYears = days / 60190.03

  private def round(value: Double): Double = (value * 100).round / 100.0
}
