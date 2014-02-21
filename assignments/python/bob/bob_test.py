try:
    import bob
except ImportError:
    raise SystemExit('Could not find bob.py. Does it exist?')

import unittest


class BobTests(unittest.TestCase):
    def setUp(self):
        self.bob = bob.Bob()

    def test_stating_something(self):
        self.assertEqual(
            'Whatever.',
            self.bob.hey('Tom-ay-to, tom-aaaah-to.')
        )

    def test_shouting(self):
        self.assertEqual(
            'Woah, chill out!',
            self.bob.hey('WATCH OUT!')
        )

    def test_asking_a_question(self):
        self.assertEqual(
            'Sure.',
            self.bob.hey('Does this cryogenic chamber make me look fat?')
        )

    def test_asking_a_numeric_question(self):
        self.assertEqual(
            'Sure.',
            self.bob.hey('You are, what, like 15?')
        )

    def test_talking_forcefully(self):
        self.assertEqual(
            'Whatever.',
            self.bob.hey("Let's go make out behind the gym!")
        )

    def test_using_acronyms_in_regular_speech(self):
        self.assertEqual(
            'Whatever.', self.bob.hey("It's OK if you don't want to go to the DMV.")
        )

    def test_forceful_questions(self):
        self.assertEqual(
            'Woah, chill out!', self.bob.hey('WHAT THE HELL WERE YOU THINKING?')
        )

    def test_shouting_numbers(self):
        self.assertEqual(
            'Woah, chill out!', self.bob.hey('1, 2, 3 GO!')
        )

    def test_only_numbers(self):
        self.assertEqual(
            'Whatever.', self.bob.hey('1, 2, 3')
        )

    def test_question_with_only_numbers(self):
        self.assertEqual(
            'Sure.', self.bob.hey('4?')
        )

    def test_shouting_with_special_characters(self):
        self.assertEqual(
            'Woah, chill out!', self.bob.hey('ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!')
        )

    def test_shouting_with_umlauts(self):
        self.assertEqual(
            'Woah, chill out!', self.bob.hey(u"\xdcML\xc4\xdcTS!")
        )

    def test_calmly_speaking_with_umlauts(self):
        self.assertEqual(
            'Whatever.', self.bob.hey(u"\xdcML\xe4\xdcTS!")
        )

    def test_shouting_with_no_exclamation_mark(self):
        self.assertEqual(
            'Woah, chill out!', self.bob.hey('I HATE YOU')
        )

    def test_statement_containing_question_mark(self):
        self.assertEqual(
            'Whatever.', self.bob.hey('Ending with ? means a question.')
        )

    def test_prattling_on(self):
        self.assertEqual(
            'Sure.', self.bob.hey("Wait! Hang on. Are you going to be OK?")
        )

    def test_silence(self):
        self.assertEqual(
            'Fine. Be that way!', self.bob.hey('')
        )

    def test_prolonged_silence(self):
        self.assertEqual(
            'Fine. Be that way!', self.bob.hey('    ')
        )

if __name__ == '__main__':
    unittest.main()
