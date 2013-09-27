import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Series (digits, slices)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList seriesTests ]

seriesTests :: [Test]
seriesTests =
  [ testCase "digits" $ do
    [0..4] @=? digits ['0'..'4']
    [0..9] @=? digits ['0'..'9']
    [9,8..0] @=? digits ['9','8'..'0']
    [3,1,3,3,7] @=? digits "31337"
    replicate 10 0 @=? take 10 (digits (repeat '0'))
  , testCase "slices of one" $ do
    [] @=? slices 1 ""
    [[0],[1],[2],[3],[4]] @=? slices 1 [0..(4::Int)]
    ["0","1","2","3","4"] @=? slices 1 ['0'..'4']
  , testCase "slices of two" $ do
    [] @=? slices 2 ""
    ["ab"] @=? slices 2 "ab"
    ["ab", "bc", "cd", "de"] @=? slices 2 "abcde"
  , testCase "slices of three" $ do
    [] @=? slices 3 "ab"
    ["abc"] @=? slices 3 "abc"
    ["abc", "bcd"] @=? slices 3 "abcd"
  ]
