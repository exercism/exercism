import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Palindromes (largestPalindrome, smallestPalindrome)
import qualified Data.Set as S

-- largestPalindrome, smallestPalindrome :: Integral a -> a -> a -> (a,[(a, a)])
-- largestPalindrome minFactor maxFactor = (value, [(factor1, factor2)])

-- It's ok to return duplicates in the factor list, and the order of the factors
-- is irrelevant.

-- You should consider using a slightly different algorithm to find small or
-- large palindromes.

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList palindromesTests ]

norm :: Ord a => [(a, a)] -> [(a, a)]
norm = S.toList . S.fromList . map normPair
  where normPair p@(a, b) = if b < a then (b, a) else p

palindromesTests :: [Test]
palindromesTests =
  [ testCase "largest palindrome from single digit factors" $ do
    let (largest, factors) = largestPalindrome 1 9
    (9 :: Int) @=? largest
    [(1, 9), (3, 3)] @=? norm factors
  , testCase "smallest palindrome from single digit factors" $ do
    let (smallest, factors) = smallestPalindrome 1 9
    (1 :: Int) @=? smallest
    [(1, 1)] @=? norm factors
    , testCase "largest palindrome from double digit factors" $ do
    let (largest, factors) = largestPalindrome 10 99
    (9009 :: Int) @=? largest
    [(91, 99)] @=? norm factors
  , testCase "smallest palindrome from double digit factors" $ do
    let (smallest, factors) = smallestPalindrome 10 99
    (121 :: Int) @=? smallest
    [(11, 11)] @=? norm factors
  , testCase "largest palindrome from triple digit factors" $ do
    let (largest, factors) = largestPalindrome 100 999
    (906609 :: Int) @=? largest
    [(913, 993)] @=? norm factors
  , testCase "smallest palindrome from triple digit factors" $ do
    let (smallest, factors) = smallestPalindrome 100 999
    (10201 :: Int) @=? smallest
    [(101, 101)] @=? norm factors
  , testCase "largest palindrome from four digit factors" $ do
    let (largest, factors) = largestPalindrome 1000 9999
    (99000099 :: Int) @=? largest
    [(9901, 9999)] @=? norm factors
  , testCase "smallest palindrome from four digit factors" $ do
    let (smallest, factors) = smallestPalindrome 1000 9999
    (1002001 :: Int) @=? smallest
    [(1001,1001)] @=? norm factors
  , testCase "largest palindrome from five digit factors" $ do
    let (largest, factors) = largestPalindrome 10000 99999
    (9966006699 :: Integer) @=? largest
    [(99681, 99979)] @=? norm factors
  , testCase "smallest palindrome from five digit factors" $ do
    let (smallest, factors) = smallestPalindrome 10000 99999
    (100020001 :: Integer) @=? smallest
    [(10001,10001)] @=? norm factors
  ]
