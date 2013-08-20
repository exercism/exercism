module Scrabble (scoreLetter, scoreWord) where
import qualified Data.Map as M
import Data.Maybe (fromJust)
import Data.Char (toUpper)

scoreLetter :: Char -> Int
scoreLetter = fromJust . flip M.lookup scoreMap . toUpper
  where
    scoreMap = M.fromList $ concatMap invert scoreGroups
    invert (score, letters) = zip letters (repeat score)
    scoreGroups =
      [ (1, "AEIOULNRST")
      , (2, "DG")
      , (3, "BCMP")
      , (4, "FHVWY")
      , (5, "K")
      , (8, "JX")
      , (10, "QZ")
      ]

scoreWord :: String -> Int
scoreWord = sum . map scoreLetter