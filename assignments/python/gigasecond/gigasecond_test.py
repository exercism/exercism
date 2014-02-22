try:
    from gigasecond import Gigasecond
except ImportError:
    raise SystemExit('Could not find gigasecond.py. Does it exist?')

from datetime import date
import unittest


class GigasecondTest(unittest.TestCase):
    def test_1(self):
        self.assertEqual(
            date(2043, 1, 1),
            Gigasecond(date(2011, 4, 25)).date
        )

    def test_2(self):
        self.assertEqual(
            date(2009, 2, 19),
            Gigasecond(date(1977, 6, 13)).date
        )

    def test_3(self):
        self.assertEqual(
            date(1991, 3, 27),
            Gigasecond(date(1959, 7, 19)).date
        )

    def test_yourself(self):
        # customize this to test your birthday and find your gigasecond date:
        your_birthday = date(1970, 1, 1)
        your_gigasecond = date(2001, 9, 9)

        self.assertEqual(
            your_gigasecond,
            Gigasecond(your_birthday).date
        )

if __name__ == '__main__':
    unittest.main()
