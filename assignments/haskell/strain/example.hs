module Strain (keep, discard) where

keep, discard :: (a -> Bool) -> [a] -> [a]

keep p (x:xs) = (if p x then (x:) else id) $ keep p xs
keep _ []     = []

discard = keep . (not .)
