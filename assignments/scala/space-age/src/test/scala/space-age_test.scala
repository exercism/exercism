import org.scalatest._

class SpaceAgeSpecs extends FunSuite with Matchers {
  test ("age in seconds") {
    val age = SpaceAge(1000000)
    age.seconds should be (1000000)
  }

  test ("age in earth years") {
    pending
    val age = SpaceAge(1000000000)
    age.onEarth should be (31.69)
  }

  test ("age in mercury years") {
    pending
    val age = SpaceAge(2134835688)
    age.onEarth should be (67.65)
    age.onMercury should be (280.88)
  }

  test ("age in venus years") {
    pending
    val age = SpaceAge(189839836)
    age.onEarth should be (6.02)
    age.onVenus should be (9.78)
  }

  test ("age on mars") {
    pending
    val age = SpaceAge(2329871239L)
    age.onEarth should be (73.83)
    age.onMars should be (39.25)
  }

  test ("age on jupiter") {
    pending
    val age = SpaceAge(901876382)
    age.onEarth should be (28.58)
    age.onJupiter should be (2.41)
  }

  test ("age on saturn") {
    pending
    val age = SpaceAge(3000000000L)
    age.onEarth should be (95.06)
    age.onSaturn should be (3.23)
  }

  test ("age on uranus") {
    pending
    val age = SpaceAge(3210123456L)
    age.onEarth should be (101.72)
    age.onUranus should be (1.21)
  }

  test ("age on neptune") {
    pending
    val age = SpaceAge(8210123456L)
    age.onEarth should be (260.16)
    age.onNeptune should be (1.58)
  }
}
