try:
    from school import School
except ImportError:
    raise SystemExit('Could not find school.py. Does it exist?')

import unittest

class SchoolTest(unittest.TestCase):
    def setUp(self):
        self.school = School("Haleakala Hippy School")
  
    def test_an_empty_school(self):
        self.assertEqual({}, self.school.db)
  
    def test_add_student(self):
        self.school.add("Aimee", 2)
        self.assertEqual({2: {"Aimee"}}, self.school.db)
  
    def test_add_more_students_in_same_class(self):
        self.school.add("James", 2)
        self.school.add("Blair", 2)
        self.school.add("Paul", 2)
        self.assertEqual({2: {"James", "Blair", "Paul"}}, self.school.db)
  
    def test_add_students_to_different_grades(self):
        self.school.add("Chelsea", 3)
        self.school.add("Logan", 7)
        self.assertEqual({3: {"Chelsea"}, 7: {"Logan"}}, self.school.db)
  
    def test_get_students_in_a_grade(self):
        self.school.add("Franklin", 5)
        self.school.add("Bradley", 5)
        self.school.add("Jeff", 1)
        self.assertEqual({"Franklin", "Bradley"}, self.school.grade(5))
  
    def test_get_students_in_a_non_existant_grade(self):
        self.assertEqual(set(), self.school.grade(1))
  
    def test_sort_school(self):
        self.school.add("Jennifer", 4)
        self.school.add("Kareem", 6)
        self.school.add("Christopher", 4)
        self.school.add("Kyle", 3)
        sorted_students = {
          3: ("Kyle",),
          4: ("Christopher", "Jennifer",),
          6: ("Kareem",)
        }
        self.assertEqual(sorted_students, self.school.sort())

if __name__ == '__main__':
    unittest.main()
