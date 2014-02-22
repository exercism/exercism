from binary import Binary
import unittest


class BinaryTests(unittest.TestCase):
    def test_binary_1_is_decimal_1(self):
        self.assertEqual(1, int(Binary("1")))

    def test_binary_10_is_decimal_2(self):
        self.assertEqual(2, int(Binary("10")))

    def test_binary_11_is_decimal_3(self):
        self.assertEqual(3, int(Binary("11")))

    def test_binary_100_is_decimal_4(self):
        self.assertEqual(4, int(Binary("100")))

    def test_binary_1001_is_decimal_9(self):
        self.assertEqual(9, int(Binary("1001")))

    def test_binary_11010_is_decimal_26(self):
        self.assertEqual(26, int(Binary("11010")))

    def test_binary_10001101000_is_decimal_1128(self):
        self.assertEqual(1128, int(Binary("10001101000")))

    def test_invalid_binary_is_decimal_0(self):
        self.assertEqual(0, int(Binary("carrot")))

if __name__ == '__main__':
    unittest.main()
