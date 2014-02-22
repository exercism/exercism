from scrabble import Word
import unittest


class WordTest(unittest.TestCase):
    def test_empty_word_scores_zero(self):
        self.assertEqual(0, Word("").score())

    def test_whitespace_scores_zero(self):
        self.assertEqual(0, Word(" \t\n").score())

    def test_scores_very_short_word(self):
        self.assertEqual(1, Word('a').score())

    def test_scores_other_very_short_word(self):
        self.assertEqual(4, Word('f').score())

    def test_simple_word_scores_the_number_of_letters(self):
        self.assertEqual(6, Word("street").score())

    def test_complicated_word_scores_more(self):
        self.assertEqual(22, Word("quirky").score())

    def test_scores_are_case_insensitive(self):
        self.assertEqual(20, Word("MULTIBILLIONAIRE").score())

if __name__ == '__main__':
    unittest.main()
