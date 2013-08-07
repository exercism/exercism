import unittest

from bob import Bob


class TeenagerTest(unittest.TestCase):
    def setUp(self):
        self.teenager = Bob()

    def test_stating_something(self):
        self.assertEqual('Whatever.', self.teenager.hey('Tom-ay-to, tom-aaaah-to.'))

    @unittest.skip("Unskip once you are ready.")
    def test_shouting(self):
        self.assertEqual('Woah, chill out!', self.teenager.hey('WATCH OUT!'))

    @unittest.skip("Unskip once you are ready.")
    def test_asking_a_question(self):
        self.assertEqual('Sure.', self.teenager.hey('Does this cryogenic chamber make me look fat?'))

    @unittest.skip("Unskip once you are ready.")
    def test_talking_forcefully(self):
        self.assertEqual('Whatever.', self.teenager.hey("Let's go make out behind the gym!"))

    @unittest.skip("Unskip once you are ready.")
    def test_using_acronyms_in_regular_speech(self):
        self.assertEqual('Whatever.', self.teenager.hey("It's OK if you don't want to go to the DMV."))

    @unittest.skip("Unskip once you are ready.")
    def test_forceful_questions(self):
        self.assertEqual('Woah, chill out!', self.teenager.hey('WHAT THE HELL WERE YOU THINKING?'))

    @unittest.skip("Unskip once you are ready.")
    def test_shouting_numbers(self):
        self.assertEqual('Woah, chill out!', self.teenager.hey('1, 2, 3 GO!'))

    @unittest.skip("Unskip once you are ready.")
    def test_shouting_with_special_characters(self):
        self.assertEqual('Woah, chill out!', self.teenager.hey('ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!'))

    @unittest.skip("Unskip once you are ready.")
    def test_shouting_with_no_exclamation_mark(self):
        self.assertEqual('Woah, chill out!', self.teenager.hey('I HATE YOU'))

    @unittest.skip("Unskip once you are ready.")
    def test_statement_containing_question_mark(self):
        self.assertEqual('Whatever.', self.teenager.hey('ing with ? means a question.'))

    @unittest.skip("Unskip once you are ready.")
    def test_silence(self):
        self.assertEqual('Fine. Be that way!', self.teenager.hey(''))

    @unittest.skip("Unskip once you are ready.")
    def test_more_silence(self):
        self.assertEqual('Fine. Be that way!', self.teenager.hey(None))

    @unittest.skip("Unskip once you are ready.")
    def test_long_silence(self):
        self.assertEqual('Fine. Be that way!', self.teenager.hey('        '))

if __name__ == '__main__':
        unittest.main()
