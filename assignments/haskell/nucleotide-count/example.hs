module DNA (count, nucleotideCounts) where
import Data.Map.Strict (Map, fromListWith)

count :: Char -> String -> Int
count needle = length . filter (nucleotide ==) . map verifyNucleotide
  where nucleotide = verifyNucleotide needle

nucleotideCounts :: String -> Map Char Int
nucleotideCounts strand = fromListWith (+) (defaults ++ map pair strand)
 where defaults = zip dna (repeat 0)
       pair nucleotide = (verifyDNA nucleotide, 1)

dna :: String
dna = "ACGT"

verifyNucleotide :: Char -> Char
verifyNucleotide 'U' = 'U'
verifyNucleotide nucleotide = verifyDNA nucleotide

verifyDNA :: Char -> Char
verifyDNA nucleotide | nucleotide `elem` dna = nucleotide
                     | otherwise = error ("invalid nucleotide " ++
                                          show nucleotide)
