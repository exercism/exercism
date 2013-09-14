module Series (digits, slices) where

import Data.Char (digitToInt)
import Data.List (tails)

digits :: String -> [Int]
digits = map digitToInt

slices :: Int -> [a] -> [[a]]
slices n s = map (take n) $ take (length s - n + 1) (tails s)
