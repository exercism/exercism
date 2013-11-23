try:
    from dna import DNA
except ImportError:
    raise SystemExit('Could not find dna.py. Does it exist?')

import unittest

class DNATest(unittest.TestCase):
    def test_no_difference_between_empty_strands(self):
        self.assertEqual(0, DNA('').hamming_distance(''))
  
    def test_no_difference_between_identical_strands(self):
        self.assertEqual(0, DNA('GGACTGA').hamming_distance('GGACTGA'))
  
    def test_complete_hamming_distance_in_small_strand(self):
        self.assertEqual(3, DNA('ACT').hamming_distance('GGA'))
  
    def test_hamming_distance_in_off_by_one_strand(self):
        self.assertEqual(19, DNA('GGACGGATTCTGACCTGGACTAATTTTGGGG').hamming_distance('AGGACGGATTCTGACCTGGACTAATTTTGGGG'))
  
    def test_small_hamming_distance_in_middle_somewhere(self):
        self.assertEqual(1, DNA('GGACG').hamming_distance('GGTCG'))
  
    def test_larger_distance(self):
        self.assertEqual(2, DNA('ACCAGGG').hamming_distance('ACTATGG'))
  
    def test_ignores_extra_length_on_other_strand_when_longer(self):
        self.assertEqual(3, DNA('AAACTAGGGG').hamming_distance('AGGCTAGCGGTAGGAC'))
  
    def test_ignores_extra_length_on_original_strand_when_longer(self):
        self.assertEqual(5, DNA('GACTACGGACAGGGTAGGGAAT').hamming_distance('GACATCGCACACC'))
  
    def test_does_not_actually_shorten_original_strand(self):
        self.assertEqual(1, DNA('AGACAACAGCCAGCCGCCGGATT').hamming_distance('AGGCAA'))
        self.assertEqual(4, DNA('AGACAACAGCCAGCCGCCGGATT').hamming_distance('AGACATCTTTCAGCCGCCGGATTAGGCAA'))
        self.assertEqual(1, DNA('AGACAACAGCCAGCCGCCGGATT').hamming_distance('AGG'))

if __name__ == '__main__':
    unittest.main()
