import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import Prime (nth)

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = void $ runTestTT $ TestList
       [ TestList primeTests ]

primeTests :: [Test]
primeTests = map TestCase
  [ 2 @=? nth 1
  , 3 @=? nth 2
  , 13 @=? nth 6
  , [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71] @=?
    map nth [1..20]
  , 7919 @=? nth 1000
  , 104729 @=? nth 10000
  , 104743 @=? nth 10001
  ]
