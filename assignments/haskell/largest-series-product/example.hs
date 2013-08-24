module Series (digits, slices, largestProduct) where
import Data.Char (digitToInt)
import Data.List (tails, foldl')

digits :: Integral a => String -> [a]
digits = map $ fromIntegral . digitToInt

slices :: Integral a => Int -> String -> [[a]]
slices n = go . digits
  where go xs = map (take n) $ take (length xs - pred n) (tails xs)

largestProduct :: Integral a => Int -> String -> a
largestProduct n = maximum . (1:) . map (foldl' (*) 1) . slices n
