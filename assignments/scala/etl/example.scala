object ETL {
  def transform(m: Map[Int, Seq[String]]): Map[String, Int] = m.flatMap { case (key, strings) =>
    Map(strings.map(_.toLowerCase -> key): _*)
  }
}
