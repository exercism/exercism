import scala.collection.immutable.SortedMap

class School {
  type DB = Map[Int, Seq[String]]

  private var _db: DB = Map.empty

  def db: DB = _db

  def add(name: String, g: Int) {
    _db = db.updated(g, grade(g) :+ name)
  }

  def grade(g: Int): Seq[String] = {
    db.getOrElse(g, Vector.empty)
  }

  def sorted: DB = SortedMap(db.toSeq: _*).mapValues(_.sorted)
}
