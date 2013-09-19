import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Hexadecimal (hexToInt)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList hexTests ]

hexTests :: [Test]
hexTests = map TestCase
  [ 1 @=? hexToInt "1"
  , 12 @=? hexToInt "c"
  , 16 @=? hexToInt "10"
  , 175 @=? hexToInt "af"
  , 256 @=? hexToInt "100"
  , 105166 @=? hexToInt "19ace"
  , 0 @=? hexToInt "carrot"
  , 0 @=? hexToInt "000000"
  , 16777215 @=? hexToInt "ffffff"
  , 16776960 @=? hexToInt "ffff00"
  ]