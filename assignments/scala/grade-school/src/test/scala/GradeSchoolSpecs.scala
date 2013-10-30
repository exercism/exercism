import org.scalatest._

class GradeSchoolSpecs extends FunSuite with Matchers with OneInstancePerTest {
  val school = new School

  test ("empty school") {
    school.db should be (Map())
  }

  test ("add student") {
    pending
    school.add("Aimee", 2)
    school.db should be (Map(2 -> Seq("Aimee")))
  }

  test ("add more students in same class") {
    pending
    school.add("James", 2)
    school.add("Blair", 2)
    school.add("Paul", 2)
    school.db should be (Map(2 -> Seq("James", "Blair", "Paul")))
  }

  test ("add students to different grades") {
    pending
    school.add("Chelsea", 3)
    school.add("Logan", 7)
    school.db should be (Map(3 -> Seq("Chelsea"), 7 -> Seq("Logan")))
  }

  test ("get students in a grade") {
    pending
    school.add("Franklin", 5)
    school.add("Bradley", 5)
    school.add("Jeff", 1)
    school.grade(5) should be (Seq("Franklin", "Bradley"))
  }

  test ("get students in a non-existant grade") {
    pending
    school.grade(1) should be (Seq())
  }

  test ("sort school") {
    pending
    school.add("Jennifer", 4)
    school.add("Kareem", 6)
    school.add("Christopher", 4)
    school.add("Kyle", 3)
    val sorted = Map(
      3 -> Seq("Kyle"),
      4 -> Seq("Christopher", "Jennifer"),
      6 -> Seq("Kareem")
    )
    school.sorted should be (sorted)
    school.sorted.keys.toList should be (Seq(3, 4, 6))
  }
}
