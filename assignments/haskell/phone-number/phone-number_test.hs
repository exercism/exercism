import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Phone (areaCode, number, prettyPrint)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList numberTests
       , TestList areaCodeTests
       , TestList prettyPrintTests ]

numberTests :: [Test]
numberTests =
  [ testCase "cleans number" $
    "1234567890" @=? number "(123) 456-7890"
  , testCase "cleans number with dots" $
    "1234567890" @=? number "123.456.7890"
  , testCase "valid when 11 digits and first is 1" $
    "1234567890" @=? number "11234567890"
  , testCase "invalid when 11 digits" $
    "0000000000" @=? number "21234567890"
  , testCase "invalid when 9 digits" $
    "0000000000" @=? number "123456789"
  , testCase "invalid when empty" $
    "0000000000" @=? number ""
  , testCase "invalid when no digits present" $
    "0000000000" @=? number " (-) "
  ]

areaCodeTests :: [Test]
areaCodeTests =
  [ testCase "area code" $
    "123" @=? areaCode "1234567890"
  ]

prettyPrintTests :: [Test]
prettyPrintTests =
  [ testCase "pretty print" $
    "(123) 456-7890" @=? prettyPrint "1234567890"
  , testCase "pretty print with full us phone number" $
    "(123) 456-7890" @=? prettyPrint "11234567890"
  ]
