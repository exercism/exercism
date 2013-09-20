import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Gigasecond (fromDay)
import Data.Time.Calendar (fromGregorian)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList gigasecondTests ]

gigasecondTests :: [Test]
gigasecondTests =
  [ testCase "from apr 25 2011" $
    fromGregorian 2043 1 1 @=? fromDay (fromGregorian 2011 04 25)
  , testCase "from jun 13 1977" $
    fromGregorian 2009 2 19 @=? fromDay (fromGregorian 1977 6 13)
  , testCase "from jul 19 1959" $
    fromGregorian 1991 3 27 @=? fromDay (fromGregorian 1959 7 19)
    -- customize this to test your birthday and find your gigasecond date:
  ]
