module PrimeFactors (primeFactors) where

primes :: [Integer]
primes = 2 : filter ((==1) . length . primeFactors) [3,5..]

primeFactors :: Integer -> [Integer]
primeFactors start | start < 2 = []
                   | otherwise = factor start primes
  where
    factor n (p:ps)
        | p*p > n        = [n]
        | n `mod` p == 0 = p : factor (n `div` p) (p:ps)
        | otherwise      = factor n ps
    factor _ _ = undefined
