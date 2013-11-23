try:
    from wordcount import Phrase
except ImportError:
    raise SystemExit('Could not find wordcount.py. Does it exist?')

import unittest

class WordCountTests(unittest.TestCase):
    def test_count_one_word(self):
        self.assertEqual(
            {'word': 1},
            Phrase('word').word_count()
        )

    def test_count_one_of_each(self):
        self.assertEqual(
            {'one': 1, 'of': 1, 'each': 1},
            Phrase('one of each').word_count()
        )

    def test_count_multiple_occurences(self):
        self.assertEqual(
            {'one': 1, 'fish': 4, 'two': 1, 'red': 1, 'blue': 1},
            Phrase('one fish two fish red fish blue fish').word_count()
        )

    def test_ignore_punctuation(self):
        self.assertEqual(
            {'car': 1, 'carpet': 1, 'as': 1, 'java': 1, 'javascript': 1},
            Phrase('car : carpet as java : javascript!!&@$%^&').word_count()
        )

    def test_include_numbers(self):
        self.assertEqual(
            {'testing': 2, '1': 1, '2': 1},
            Phrase('testing, 1, 2 testing').word_count()
        )

    def test_normalize_case(self):
        self.assertEqual(
            {'go': 3},
            Phrase('go Go GO').word_count()
        )

if __name__ == '__main__':
    unittest.main()
