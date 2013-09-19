import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Say (inEnglish)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList inEnglishTests ]

inEnglishTests :: [Test]
inEnglishTests =
  [ testCase "zero" $
    Just "zero" @=? inEnglish (0::Int)
  , testCase "one" $
    Just "one" @=? inEnglish (1::Integer)
  , testCase "fourteen" $
    Just "fourteen" @=? inEnglish (14::Int)
  , testCase "twenty" $
    Just "twenty" @=? inEnglish (20::Int)
  , testCase "twenty-two" $
    Just "twenty-two" @=? inEnglish (22::Int)
  , testCase "one hundred" $
    Just "one hundred" @=? inEnglish (100::Int)
  , testCase "one hundred twenty-three" $
    Just "one hundred twenty-three" @=? inEnglish (123::Int)
  , testCase "one thousand" $
    Just "one thousand" @=? inEnglish (1000::Int)
  , testCase "one thousand two hundred thirty-four" $
    Just "one thousand two hundred thirty-four" @=? inEnglish (1234::Int)
  , testCase "one million" $
    Just "one million" @=? inEnglish (1000000::Int)
  , testCase "one million two" $
    Just "one million two" @=? inEnglish (1000002::Int)
  , testCase "one million two thousand three hundred forty-five" $
    Just "one million two thousand three hundred forty-five" @=?
    inEnglish (1002345::Int)
  , testCase "one billion" $
    Just "one billion" @=? inEnglish (1000000000::Int)
  , testCase "a big number" $
    Just "nine hundred eighty-seven billion six hundred fifty-four million \
         \three hundred twenty-one thousand one hundred twenty-three" @=?
    inEnglish (987654321123::Integer)
  , testCase "lower bound" $
    Nothing @=? inEnglish (-1::Integer)
  , testCase "upper bound" $
    Nothing @=? inEnglish (1000000000000::Integer)
  ]
