module Grains (square, total) where

square :: Int -> Integer
square = (2 ^) . pred

total :: Integer
total = pred $ 2 ^ (64 :: Int)
