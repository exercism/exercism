import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import Strain (keep, discard)
import Data.List (isPrefixOf)
testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = void $ runTestTT $ TestList
       [ TestList strainTests ]

ints :: [Int] -> [Int]
ints = id

strainTests :: [Test]
strainTests =
  [ testCase "empty keep" $
    ints [] @=? keep (<10) []
  , testCase "keep everything" $
    ints [1, 2, 3] @=? keep (<10) [1, 2, 3]
  , testCase "keep first and last" $
    ints [1, 3] @=? keep odd [1, 2, 3]
  , testCase "keep nothing" $
    ints [] @=? keep even [1,3,5,7]
  , testCase "keep neither first nor last" $
    ints [2] @=? keep even [1, 2, 3]
  , testCase "keep strings" $ do
    let ws = ["apple", "zebra", "banana", "zombies", "cherimoya", "zealot"]
    ["zebra", "zombies", "zealot"] @=? keep (isPrefixOf "z") ws
  , testCase "empty discard" $
    ints [] @=? discard (<10) []
  , testCase "discard everything" $
    ints [] @=? discard (<10) [1, 2, 3]
  , testCase "discard first and last" $
    ints [2] @=? discard odd [1, 2, 3]
  , testCase "discard nothing" $
    ints [1,3,5,7] @=? discard even [1,3,5,7]
  , testCase "discard neither first nor last" $
    ints [1, 3] @=? discard even [1, 2, 3]
  , testCase "discard strings" $ do
    let ws = ["apple", "zebra", "banana", "zombies", "cherimoya", "zealot"]
    ["apple", "banana", "cherimoya"] @=? discard (isPrefixOf "z") ws
  ]
