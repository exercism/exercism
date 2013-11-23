import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Squares (sumOfSquares, squareOfSums, difference)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList squaresTests ]

int :: Int -> Int
int = id

integer :: Integer -> Integer
integer = id

-- To add a little extra challenge, these functions should work with any
-- instance of the Integral typeclass.
squaresTests :: [Test]
squaresTests =
  [ testCase "square of sums to 5" $
    int 225 @=? squareOfSums 5
  , testCase "sum of squares to 5" $
    int 55 @=? sumOfSquares 5
  , testCase "difference of sums to 5" $
    int 170 @=? difference 5
  , testCase "square of sums to 10" $
    int 3025 @=? squareOfSums 10
  , testCase "sum of squares to 10" $
    int 385 @=? sumOfSquares 10
  , testCase "difference of sums to 10" $
    int 2640 @=? difference 10
  , testCase "square of sums to 100" $
    integer 25502500 @=? squareOfSums 100
  , testCase "sum of squares to 100" $
    integer 338350 @=? sumOfSquares 100
  , testCase "difference of sums to 100 (Int)" $
    int 25164150 @=? difference 100
  , testCase "difference of sums to 100 (Integer)" $
    integer 25164150 @=? difference 100
  ]
