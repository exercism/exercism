module Sieve (primesUpTo) where

import Control.Monad (when)
import qualified Data.Vector as V
import qualified Data.Vector.Mutable as MV

primesUpTo :: Int -> [Int]
primesUpTo upperBound = V.ifoldr f [] $ V.create $ do
  mv <- MV.replicate (1 + upperBound) (1 :: Int)
  when (upperBound >= 0) $ MV.write mv 0 0
  when (upperBound >= 1) $ MV.write mv 1 0
  go mv 2
  where
    f n 1 acc = n:acc
    f _ _ acc = acc
    go mv n | n > upperBound = return mv
            | otherwise      = do
              nPrime <- MV.read mv n
              when (nPrime == 1) $
                mapM_ (flip (MV.write mv) 0) [n+n, n+n+n .. upperBound]
              go mv (n + 1)
