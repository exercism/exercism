import scala.util.Random

class Robot {
  private var _name: String = makeName

  def name: String = _name

  def reset(): Unit = _name = makeName

  private def makeName = prefix + suffix

  private def prefix = Random.shuffle(Robot.alphabet).take(2).mkString

  private def suffix = Random.shuffle(Robot.suffixes).head.toString
}

object Robot {
  private val alphabet: Seq[Char] = 'A'.to('Z').toList

  private val suffixes: Seq[Int] = 100.to(999).toList
}
