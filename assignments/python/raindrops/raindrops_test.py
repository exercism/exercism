from raindrops import raindrops
import unittest


class RaindropsTest(unittest.TestCase):
    def test_1(self):
        self.assertEqual("1", raindrops(1))

    def test_3(self):
        self.assertEqual("Pling", raindrops(3))

    def test_5(self):
        self.assertEqual("Plang", raindrops(5))

    def test_7(self):
        self.assertEqual("Plong", raindrops(7))

    def test_6(self):
        self.assertEqual("Pling", raindrops(6))

    def test_9(self):
        self.assertEqual("Pling", raindrops(9))

    def test_10(self):
        self.assertEqual("Plang", raindrops(10))

    def test_14(self):
        self.assertEqual("Plong", raindrops(14))

    def test_15(self):
        self.assertEqual("PlingPlang", raindrops(15))

    def test_21(self):
        self.assertEqual("PlingPlong", raindrops(21))

    def test_25(self):
        self.assertEqual("Plang", raindrops(25))

    def test_35(self):
        self.assertEqual("PlangPlong", raindrops(35))

    def test_49(self):
        self.assertEqual("Plong", raindrops(49))

    def test_52(self):
        self.assertEqual("52", raindrops(52))

    def test_105(self):
        self.assertEqual("PlingPlangPlong", raindrops(105))

    def test_12121(self):
        self.assertEqual("12121", raindrops(12121))

if __name__ == '__main__':
    unittest.main()
