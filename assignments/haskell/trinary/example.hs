module Trinary (showTri, readTri) where

base :: Integral a => a
base = 3

showTri :: Integral a => a -> String
showTri n0 | n0 >= 0   = go (quotRem n0 base) []
           | otherwise = error "only positive numbers supported"
  where
    go (q, r) acc = c `seq` case q of
      0 -> acc'
      n -> go (quotRem n base) acc'
      where acc' = c : acc
            c = toEnum $ fromEnum '0' + fromIntegral r

readTri :: Integral a => String -> a
readTri = flip go 0
  where
    go []     acc = acc
    go (c:cs) acc | c >= '0' && c <= maxChar = acc' `seq` go cs acc'
                  | otherwise = error ("invalid Trinary digit " ++ show c)
      where acc' = acc * base + fromIntegral (fromEnum c - fromEnum '0')
            maxChar = toEnum (fromEnum '0' + pred base)