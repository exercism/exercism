module Triangle (triangle, row) where
import Data.List (foldl')

triangle :: Integral a => [[a]]
triangle = map row [1..]

row :: (Integral a) => a -> [a]
row n = map (choose n0) [0..n0]
  where n0 = n - 1

choose :: (Integral a) => a -> a -> a
choose n k = foldl' go 1 [1..k]
  where go z i = z * (n - i + 1) `div` i
