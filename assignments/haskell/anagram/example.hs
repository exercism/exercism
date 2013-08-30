module Anagram (anagramsFor) where
import Control.Applicative (liftA2)
import Data.Char (toLower)
import Data.Map (Map, fromListWith)

anagramsFor :: String -> [String] -> [String]
anagramsFor word = filter (liftA2 (&&) different anagram)
  where
    anagram = ((canonical ==) . canonicalize)
    canonical = canonicalize word
    canonicalize :: String -> Map Char Int
    canonicalize = fromListWith (+) . map key
    key char = (toLower char, 1)
    different = (word /=)
