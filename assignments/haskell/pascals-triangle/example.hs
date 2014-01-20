module Triangle (triangle, row) where

triangle :: Integral a => [[a]]
triangle = map row [1..]

row :: (Integral a) => a -> [a]
row n = reflect [] $ scanl choices 1 [1 .. pred n `div` 2]
  where
    reflect acc [] | odd n     = tail acc
                   | otherwise = acc
    reflect acc (x:xs) = x : reflect (x:acc) xs
    choices z i = z * (n - i) `div` i
