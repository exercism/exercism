import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import Accumulate (accumulate)
import System.Exit (ExitCode(..), exitWith)
import Data.Char (toUpper)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList accumulateTests ]

square :: Int -> Int
square x = x * x

accumulateTests :: [Test]
accumulateTests =
  [ testCase "empty accumulation" $
    [] @=? accumulate square []
  , testCase "accumulate squares" $
    [1, 4, 9] @=? accumulate square [1, 2, 3]
  , testCase "accumulate upcases" $
    ["HELLO", "WORLD"] @=? accumulate (map toUpper) ["hello", "world"]
  , testCase "accumulate reversed strings" $
    ["eht", "kciuq", "nworb", "xof", "cte"] @=?
    accumulate reverse ["the", "quick", "brown", "fox", "etc"]
  , testCase "accumulate recursively" $
    [["a1", "a2", "a3"], ["b1", "b2", "b3"], ["c1", "c2", "c3"]] @=?
    accumulate (\c -> accumulate ((c:) . show) ([1, 2, 3] :: [Int])) "abc"
  ]