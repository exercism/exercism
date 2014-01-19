module DNA (toRNA) where

replaceThymidine :: Char -> Char
replaceThymidine c = case c of
  'C' -> 'G'
  'G' -> 'C'
  'A' -> 'U'
  'T' -> 'A'
  _ -> error $ "Invalid nucleotide " ++ show c

toRNA :: String -> String
toRNA = map replaceThymidine
