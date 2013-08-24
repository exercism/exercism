module Triangle (TriangleType(..), triangleType) where
import qualified Data.Set as S
import Data.List (sort)

data TriangleType = Equilateral
                  | Isosceles
                  | Scalene
                  | Illogical
                  deriving (Eq, Read, Show)

triangleType :: (Num a, Ord a) => a -> a -> a -> TriangleType
triangleType a b c
  | any (<=0) [a, b, c] || s1 + s2 <= s3 = Illogical
  | otherwise = [Equilateral, Isosceles, Scalene] !! pred uniqueSides
  where sortedSides  = sort [a, b, c]
        [s1, s2, s3] = sortedSides
        uniqueSides  = S.size (S.fromAscList sortedSides)
