module Palindromes (largestPalindrome, smallestPalindrome) where
import Data.Function (on)

type Comparator a = a -> a -> Ordering
type Product2 a = (a, [(a, a)])

isPalindrome :: Integral a => a -> Bool
isPalindrome x = x < base || lastDigit /= 0 && digits == reverse digits
  where base = 10
        digits@(lastDigit:_) = revDigitsBase base x

revDigitsBase :: Integral a => a -> a -> [a]
revDigitsBase base = go
  where go n = case n `quotRem` base of
          (0, r) -> [r]
          (q, r) -> r : go q

union2 :: Comparator a -> (a -> a -> a) -> [a] -> [a] -> [a]
union2 cmp merge = go
  where
    go [] ys = ys
    go xs [] = xs
    go (x:xs) (y:ys) = case cmp x y of
      GT -> y : go (x:xs) ys
      EQ -> merge x y : go xs ys
      LT -> x : go xs (y:ys)

largestPalindrome, smallestPalindrome :: Integral a => a -> a -> Product2 a
largestPalindrome a b = head $ bigPalindromes a b
smallestPalindrome a b = head $ smallPalindromes a b

bigPalindromes, smallPalindromes :: Integral a => a -> a -> [Product2 a]
bigPalindromes a b = palindromes (flip compare) [b, b-1 .. a]
smallPalindromes a b = palindromes compare [a .. b]

-- Produce a sorted list of palindromes using the factors from range.
-- Note that range must be monotonically increasing according to
-- cmp.
palindromes :: Integral a => Comparator a -> [a] -> [Product2 a]
palindromes cmp range = filter (isPalindrome . fst) $
                        unionAllBy (cmp `on` fst) merge $
                        combinationsWith combine range
  where combine a b = (a * b, [(a, b)])
        merge (a, as) (_, bs) = (a, as ++ bs)

-- All pairwise combinations as a list of lists:
-- combinationsWith (,) [1,2,3] =
--   [[(1,1), (1,2), (1,3)], [(2, 2), (2, 3)], [(3, 3)]]
combinationsWith :: (a -> a -> b) -> [a] -> [[b]]
combinationsWith f = go
  where go [] = []
        go xs@(x:xs') = map (f x) xs : go xs'

-- union a list of sorted lists, but assume the heads are presorted.
-- this optimization reduces comparisons and allows for an infinite number of
-- input lists
unionAllBy :: Comparator a -> (a -> a -> a) -> [[a]] -> [a]
unionAllBy cmp merge = go
  where
    union = union2 cmp merge
    go ((x:xs):(y:ys):rest) = x : union xs (y : ys `union` go rest)
    go rest                 = foldr union [] rest
