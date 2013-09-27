import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Prime (nth)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
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
