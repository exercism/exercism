try:
    import bob
except ImportError:
    raise SystemExit('Could not find bob.py. Does it exist?')

import unittest

class BobTests(unittest.TestCase):
    def setUp(self):
        self.bob = bob.Bob()

    def test_shouts(self):
        'Bob responds to shouting'
        self.assertEqual(
            'Woah, chill out!',
            self.bob.hey('SHOUTING')
        )

    def test_questions(self):
        'Bob responds to questions'
        self.assertEqual(
            'Sure.',
            self.bob.hey('A question?')
        )

    def test_statements(self):
        'Bob responds to statements'
        self.assertEqual(
            'Whatever.',
            self.bob.hey('A statement.')
        )

    def test_silence(self):
        'Bob responds to silence'
        self.assertEqual(
            'Fine, be that way.',
            self.bob.hey('')
        )

if __name__ == '__main__':
    unittest.main()
