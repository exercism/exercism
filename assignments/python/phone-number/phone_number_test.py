try:
    from phone import Phone
except ImportError:
    raise SystemExit('Could not find phone.py. Does it exist?')

import unittest

class PhoneTest(unittest.TestCase):
    def test_cleans_number(self):
        number = Phone("(123) 456-7890").number
        self.assertEqual("1234567890", number)
  
    def test_cleans_number_with_dots(self):
        number = Phone("123.456.7890").number
        self.assertEqual("1234567890", number)
  
    def test_valid_when_11_digits_and_first_is_1(self):
        number = Phone("11234567890").number
        self.assertEqual("1234567890", number)
  
    def test_invalid_when_11_digits(self):
        number = Phone("21234567890").number
        self.assertEqual("0000000000", number)
  
    def test_invalid_when_9_digits(self):
        number = Phone("123456789").number
        self.assertEqual("0000000000", number)
  
    def test_area_code(self):
        number = Phone("1234567890")
        self.assertEqual("123", number.area_code())
  
    def test_pretty_print(self):
        number = Phone("1234567890")
        self.assertEqual("(123) 456-7890", number.pretty())
  
    def test_pretty_print_with_full_us_phone_number(self):
        number = Phone("11234567890")
        self.assertEqual("(123) 456-7890", number.pretty())
  
if __name__ == '__main__':
    unittest.main()
