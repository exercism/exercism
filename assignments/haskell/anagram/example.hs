module Anagram (anagramsFor) where
import Data.Char (toLower)
import Data.List (sort)

anagramsFor :: String -> [String] -> [String]
anagramsFor word = filter isDifferent
  where
    la = map toLower word
    sa = sort la
    isDifferent b = la /= lb && sa == sb
      where lb = map toLower b
            sb = sort lb
