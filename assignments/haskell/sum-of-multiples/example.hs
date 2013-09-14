module SumOfMultiples (sumOfMultiples, sumOfMultiplesDefault) where

sumOfMultiplesDefault :: Int -> Int
sumOfMultiplesDefault = sumOfMultiples [3, 5]

sumOfMultiples :: [Int] -> Int -> Int
sumOfMultiples targets upperBound = sum (filter f [1..upperBound-1])
  where f n = any ((==0) . mod n) targets
