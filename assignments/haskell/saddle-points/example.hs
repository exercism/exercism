module Matrix (saddlePoints) where
import Data.Array (Ix, Array, assocs, bounds)
import Data.Monoid (Monoid, mappend, mempty)
import Data.Maybe (maybeToList)
import Data.Functor ((<$>))
import Control.Monad (guard)
import qualified Data.Set as S
import qualified Data.Map as M

data Axis a b = Row !a
              | Col !b
          deriving (Show, Eq, Ord)

class Extrema a where
  ecmp :: Ord b => a -> b -> b -> Ordering

data Min = Min deriving (Show)
data Max = Max deriving (Show)

instance Extrema Min where
  ecmp _ = compare

instance Extrema Max where
  ecmp _ = flip compare

data Extremes a b c = Extremes !a !b !c deriving (Show)

instance (Extrema a, Ord b, Monoid c) => Monoid (Extremes a b c) where
  mempty = undefined
  mappend a@(Extremes ea xa as) b@(Extremes _ xb bs) = case ecmp ea xa xb of
    LT -> a
    EQ -> Extremes ea xa (as `mappend` bs)
    GT -> b

extrema :: (Ix a, Ix b, Ord c)
           => Array (a, b) c
           -> M.Map (Axis a b) ( Extremes Min c (S.Set (a, b))
                               , Extremes Max c (S.Set (a, b)))
extrema = M.fromListWith mappend . expand . assocs
  where expand xs = do
          (ix@(row, col), x) <- xs
          let s = S.singleton ix
          ax <- [Row row, Col col]
          return (ax, (Extremes Min x s, Extremes Max x s))

-- This is so generic with regard to extrema as it was designed
-- to find either type of saddle point. The readme for this exercise
-- at the time had a definition that was inconsistent with the tests.
saddlePoints :: Array (Int, Int) Int -> [(Int, Int)]
saddlePoints arr = do
  let getMin (Extremes Min a as, _) = (a, as)
      getMax (_, Extremes Max b bs) = (b, bs)
      fetch f k = maybeToList $ f <$> M.lookup k m
      ((r0, _c0), (r1, _c1)) = bounds arr
      m = extrema arr
  r <- [r0..r1]
  (rx, rixs) <- fetch getMax (Row r)
  rix@(_, c) <- S.toList rixs
  (cx, cixs) <- fetch getMin (Col c)
  guard $ rx == cx && rix `S.member` cixs
  return rix
