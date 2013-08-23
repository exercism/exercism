module Squares (squareOfSums, sumOfSquares, difference) where

square :: Integer -> Integer
square n = n * n

squareOfSums :: Integer -> Integer
squareOfSums n = square $ sum [1..n]

sumOfSquares :: Integer -> Integer
sumOfSquares n = sum $ map square [1..n]

difference :: Integer -> Integer
difference n = squareOfSums n - sumOfSquares n
