module Accumulate (accumulate) where
accumulate :: (a -> b) -> [a] -> [b]
accumulate = map
{-

-- Some other definitions that are easily possible:

accumulate = fmap

accumulate f = foldr ((:) . f) []

accumulate f xs = [f x | x <- xs]

accumulate f (x:xs) = f x : accumulate xs
accumulate _ [] = []

-}
