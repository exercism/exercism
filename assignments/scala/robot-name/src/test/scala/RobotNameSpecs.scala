import org.scalatest._

class RobotNameSpecs extends FunSpec with Matchers {
  val nameRegex = """\w{2}\d{3}"""

  it ("has a name") {
    new Robot().name should fullyMatch regex (nameRegex)
  }

  it ("does not change its name") {
    pending
    val robot = new Robot
    val name = robot.name
    robot.name should be (name)
  }

  it ("does not have the same name as other robots") {
    pending
    new Robot().name should not be (new Robot().name)
  }

  it ("can have its name reset") {
    pending
    val robot = new Robot
    val name = robot.name
    robot.reset()
    val name2 = robot.name
    name should not equal (name2)
    name2 should fullyMatch regex (nameRegex)
  }
}
