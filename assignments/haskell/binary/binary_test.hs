import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Binary (toDecimal)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList binaryTests ]

binaryTests :: [Test]
binaryTests = map TestCase
  [ 1 @=? toDecimal "1"
  , 2 @=? toDecimal "10"
  , 3 @=? toDecimal "11"
  , 4 @=? toDecimal "100"
  , 9 @=? toDecimal "1001"
  , 26 @=? toDecimal "11010"
  , 1128 @=? toDecimal "10001101000"
  , 0 @=? toDecimal "carrot"
  ]
