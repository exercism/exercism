try:
    import etl
except ImportError:
    raise SystemExit('Could not find etl.py. Does it exist?')

import unittest

class TransformTest(unittest.TestCase):
    def test_transform_one_value(self):
        old = {'hello': ['WORLD']}
        expected = {'world': 'hello'}

        self.assertEqual(expected, etl.transform(old))

    def test_transform_more_values(self):
        old = {'hello':  ['WORLD', 'GSCHOOLERS']}
        expected = {'world': 'hello', 'gschoolers': 'hello'}
  
        self.assertEqual(expected, etl.transform(old))

    def test_more_keys(self):
        old = {'a': ['APPLE', 'ARTICHOKE'], 'b': ['BOAT', 'BALLERINA']}
        expected = {
            'apple': 'a',
            'artichoke': 'a',
            'boat': 'b',
            'ballerina': 'b'
        }

        self.assertEqual(expected, etl.transform(old))

    def test_full_dataset(self):
        old = {
            1: "AEIOULNRST",
            2: "DG",
            3: "BCMP",
            4: "FHVWY",
            5: "K",
            8: "JX",
            10: "QZ",
        }
  
        expected = {
          "a": 1, "b": 3, "c": 3, "d": 2, "e": 1,
          "f": 4, "g": 2, "h": 4, "i": 1, "j": 8,
          "k": 5, "l": 1, "m": 3, "n": 1, "o": 1,
          "p": 3, "q": 10, "r": 1, "s": 1, "t": 1,
          "u": 1, "v": 4, "w": 4, "x": 8, "y": 4,
          "z": 10
        }
  
        self.assertEqual(expected, etl.transform(old))

if __name__ == '__main__':
    unittest.main()
