try:
    from anagram import Anagram
except ImportError:
    raise SystemExit('Could not find anagram.py. Does it exist?')

import unittest

class AnagramTests(unittest.TestCase):
    def test_no_matches(self):
        self.assertEqual(
            [],
            Anagram('diaper').match('hello world zombies pants'.split())
        )

    def test_detect_simple_anagram(self):
        self.assertEqual(
            ['tan'],
            Anagram('ant').match('tan stand at'.split())
        )

    def test_detect_multiple_anagrams(self):
        self.assertEqual(
            ['stream', 'maters'],
            Anagram('master').match('stream pigeon maters'.split())
        )

    def test_does_not_confuse_different_duplicates(self):
        self.assertEqual(
            [],
            Anagram('galea').match(['eagle'])
        )

    def test_detect_anagram(self):
        self.assertEqual(
            ['inlets'],
            Anagram('listen').match('enlists google inlets banana'.split())
        )

    def test_multiple_anagrams(self):
        self.assertEqual(
            'gallery regally largely'.split(),
            Anagram('allergy').match('gallery ballerina regally clergy largely leading'.split())
        )

    def test_anagrams_are_case_insensitive(self):
        self.assertEqual(
            ['carthorse'],
            Anagram('Orchestra').match('cashregister carthorse radishes'.split())
        )

if __name__ == '__main__':
    unittest.main()
