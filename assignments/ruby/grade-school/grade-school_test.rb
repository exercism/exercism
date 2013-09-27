require 'minitest/autorun'
require_relative 'school'

class SchoolTest < MiniTest::Unit::TestCase

  def school
    @school
  end

  def setup
    @school = School.new
  end

  def test_an_empty_school
    assert_equal({}, school.db)
  end

  def test_add_student
    skip
    school.add("Aimee", 2)
    assert_equal({2 => ["Aimee"]}, school.db)
  end

  def test_add_more_students_in_same_class
    skip
    school.add("James", 2)
    school.add("Blair", 2)
    school.add("Paul", 2)
    assert_equal({2 => ["James", "Blair", "Paul"]}, school.db)
  end

  def test_add_students_to_different_grades
    skip
    school.add("Chelsea", 3)
    school.add("Logan", 7)
    assert_equal({3 => ["Chelsea"], 7 => ["Logan"]}, school.db)
  end

  def test_get_students_in_a_grade
    skip
    school.add("Franklin", 5)
    school.add("Bradley", 5)
    school.add("Jeff", 1)
    assert_equal ["Franklin", "Bradley"], school.grade(5)
  end

  def test_get_students_in_a_non_existant_grade
    skip
    assert_equal [], school.grade(1)
  end

  def test_sort_school
    skip
    school.add("Jennifer", 4)
    school.add("Kareem", 6)
    school.add("Christopher", 4)
    school.add("Kyle", 3)
    sorted = {
      3 => ["Kyle"],
      4 => ["Christopher", "Jennifer"],
      6 => ["Kareem"]
    }
    assert_equal sorted, school.sort
    assert_equal [3, 4, 6], school.sort.keys
  end
end
