module Prime (nth) where

nth :: Int -> Integer
nth = (primes !!) . pred

-- all primes > 5 are in the form of 6n+1 or 6n+5 (for n >= 1)
primes :: [Integer]
primes = 2 : 3 : 5 : filter (go $ drop 2 primes) candidates
  where
    candidates = [x | n6 <- [6, 12 ..], x <- [n6 + 1, n6 + 5]]
    go (p:ps) n = case n `quotRem` p of
      (_, 0) -> False
      (q, _) -> q < p || go ps n
    go _ _ = undefined
