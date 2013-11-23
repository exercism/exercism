import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Roman (numerals)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList numeralsTests ]

numeralsTests :: [Test]
numeralsTests = map TestCase $
  [ "I" @=? numerals 1
  , "II" @=? numerals 2
  , "III" @=? numerals 3
  , "IV" @=? numerals 4
  , "V" @=? numerals 5
  , "VI" @=? numerals 6
  , "IX" @=? numerals 9
  , "XXVII" @=? numerals 27
  , "XLVIII" @=? numerals 48
  , "LIX" @=? numerals 59
  , "XCIII" @=? numerals 93
  , "CXLI" @=? numerals 141
  , "CLXIII" @=? numerals 163
  , "CDII" @=? numerals 402
  , "DLXXV" @=? numerals 575
  , "CMXI" @=? numerals 911
  , "MXXIV" @=? numerals 1024
  , "MMM" @=? numerals 3000
  ]
