import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import LeapYear (isLeapYear)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList isLeapYearTests ]

isLeapYearTests :: [Test]
isLeapYearTests =
  [ testCase "vanilla leap year" $
    True @=? isLeapYear 1996
  , testCase "any old year" $
    False @=? isLeapYear 1997
  , testCase "century" $
    False @=? isLeapYear 1900
  , testCase "exceptional century" $
    True @=? isLeapYear 2400
  ]
