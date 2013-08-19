module DNA (toRNA) where

replaceThymidine :: Char -> Char
replaceThymidine 'T' = 'U'
replaceThymidine nucleotide = nucleotide

toRNA :: String -> String
toRNA = map replaceThymidine
