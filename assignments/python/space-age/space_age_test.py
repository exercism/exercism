try:
    from space_age import SpaceAge
except ImportError:
    raise SystemExit('Could not find space_age.py. Does it exist?')

import unittest


class SpaceAgeTest(unittest.TestCase):
    def test_age_in_seconds(self):
        age = SpaceAge(1e6)
        self.assertEqual(1e6, age.seconds)

    def test_age_in_earth_years(self):
        age = SpaceAge(1e9)
        self.assertEqual(31.69, age.on_earth())

    def test_age_in_mercury_years(self):
        age = SpaceAge(2134835688)
        self.assertEqual(67.65, age.on_earth())
        self.assertEqual(280.88, age.on_mercury())

    def test_age_in_venus_years(self):
        age = SpaceAge(189839836)
        self.assertEqual(6.02, age.on_earth())
        self.assertEqual(9.78, age.on_venus())

    def test_age_on_mars(self):
        age = SpaceAge(2329871239)
        self.assertEqual(73.83, age.on_earth())
        self.assertEqual(39.25, age.on_mars())

    def test_age_on_jupiter(self):
        age = SpaceAge(901876382)
        self.assertEqual(28.58, age.on_earth())
        self.assertEqual(2.41, age.on_jupiter())

    def test_age_on_saturn(self):
        age = SpaceAge(3e9)
        self.assertEqual(95.06, age.on_earth())
        self.assertEqual(3.23, age.on_saturn())

    def test_age_on_uranus(self):
        age = SpaceAge(3210123456)
        self.assertEqual(101.72, age.on_earth())
        self.assertEqual(1.21, age.on_uranus())

    def test_age_on_neptune(self):
        age = SpaceAge(8210123456)
        self.assertEqual(260.16, age.on_earth())
        self.assertEqual(1.58, age.on_neptune())

if __name__ == '__main__':
    unittest.main()
