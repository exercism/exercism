import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import Accumulate (accumulate)

import Data.Char (toUpper)

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = void $ runTestTT $ TestList
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