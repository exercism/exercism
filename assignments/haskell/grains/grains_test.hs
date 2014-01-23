import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Grains (square, total)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList grainsTests ]

i :: Integral a => a -> Integer
i = fromIntegral

grainsTests :: [Test]
grainsTests =
  [ testCase "square 1" $
    1 @=? i (square 1)
  , testCase "square 2" $
    2 @=? i (square 2)
  , testCase "square 3" $
    4 @=? i (square 3)
  , testCase "square 4" $
    8 @=? i (square 4)
  , testCase "square 16" $
    32768 @=? i (square 16)
  , testCase "square 32" $
    2147483648 @=? i (square 32)
  , testCase "square 64" $
    9223372036854775808 @=? i (square 64)
  , testCase "total grains" $
    18446744073709551615 @=? i total
  ]
