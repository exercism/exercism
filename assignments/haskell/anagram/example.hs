module Anagram (anagramsFor) where
import Data.Char (toLower)
import Data.Map (Map, fromListWith)

anagramsFor :: String -> [String] -> [String]
anagramsFor word = filter ((canonical ==) . canonicalize)
  where
    canonical = canonicalize word
    canonicalize :: String -> Map Char Int
    canonicalize = fromListWith (+) . map key
    key char = (toLower char, 1)
