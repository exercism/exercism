module Triplet ( Triplet, mkTriplet, pythagoreanTriplets, isPythagorean) where
import Control.Monad.Fix (fix)
import Data.Bits (Bits, shiftL, shiftR)

newtype Triplet a = Triplet (a, a, a)
                  deriving (Show, Eq)

mkTriplet :: Int -> Int -> Int -> Triplet Int
mkTriplet a b c | b < a     = mkTriplet b a c
                | c < b     = mkTriplet a c b
                | otherwise = Triplet (a, b, c)

isPythagorean :: Triplet Int -> Bool
isPythagorean (Triplet (a, b, c)) = square a + square b == square c

square :: Integral a => a -> a
square a = a * a

-- only correct for positive n >= 1
isqrt :: (Integral a, Bits a) => a -> a
isqrt n = go n 0 startBit
  where
    -- Calculate largest power of 4 that's >= n
    startBit = fix (\f bit -> case bit `shiftL` 2 of
                       bit' | bit' > n  -> bit
                            | otherwise -> f bit') 1
    go _   res 0   = res
    go num res bit
      | num >= resbit = go (num - resbit) (res `shiftR` 1 + bit) bit'
      | otherwise     = go num (res `shiftR` 1) bit'
      where resbit = res + bit
            bit' = bit `shiftR` 2

pythagoreanTriplets :: Int -> Int -> [Triplet Int]
pythagoreanTriplets minFactor maxFactor =
  [mkTriplet a b c
  | a <- [minFactor..maxFactor]
  , b <- [a..maxFactor]
  , let c2 = square a + square b
        c = isqrt c2
  , c <= maxFactor && c2 == square c]
