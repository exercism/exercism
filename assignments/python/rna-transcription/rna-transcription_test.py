try:
    import dna
except ImportError:
    raise SystemExit('Could not find dna.py. Does it exist?')

import unittest

class DNATests(unittest.TestCase):
    def test_transcribes_cytidine_unchanged(self):
        self.assertEqual('C', dna.DNA('C').to_rna())

    def test_transcribes_guanosine_unchanged(self):
        self.assertEqual('G', dna.DNA('G').to_rna())

    def test_transcribes_adenosine_unchanged(self):
        self.assertEqual('A', dna.DNA('A').to_rna())

    def test_transcribes_thymidine_to_uracil(self):
        self.assertEqual('U', dna.DNA('T').to_rna())

    def test_transcribes_all_occurences(self):
        self.assertEqual(
            'ACGUGGUCUUAA',
            dna.DNA('ACGTGGTCTTAA').to_rna()
        )

if __name__ == '__main__':
    unittest.main()
