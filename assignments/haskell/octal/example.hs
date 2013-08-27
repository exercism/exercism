module Octal (showOct, readOct) where

showOct :: Integral a => a -> String
showOct n0 | n0 >= 0   = go (quotRem n0 8) []
           | otherwise = error "only positive numbers supported"
  where
    go (q, r) acc = c `seq` case q of
      0 -> acc'
      n -> go (quotRem n 8) acc'
      where acc' = c : acc
            c = toEnum $ fromEnum '0' + fromIntegral r

readOct :: Integral a => String -> a
readOct = flip go 0
  where
    go []     acc = acc
    go (c:cs) acc | c >= '0' && c <= '8' = acc' `seq` go cs acc'
                  | otherwise = error ("invalid octal digit " ++ show c)
      where acc' = acc * 8 + fromIntegral (fromEnum c - fromEnum '0')