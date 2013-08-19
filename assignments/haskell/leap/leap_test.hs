import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import LeapYear (isLeapYear)

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = void $ runTestTT $ TestList
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
    True @=? isLeapYear 2000
  ]