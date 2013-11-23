import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import PrimeFactors (primeFactors)

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
  [ [] @=? primeFactors 1
  , [2] @=? primeFactors 2
  , [3] @=? primeFactors 3
  , [2, 2] @=? primeFactors 4
  , [2, 3] @=? primeFactors 6
  , [2, 2, 2] @=? primeFactors 8
  , [3, 3] @=? primeFactors 9
  , [3, 3, 3] @=? primeFactors 27
  , [5, 5, 5, 5] @=? primeFactors 625
  , [5, 17, 23, 461] @=? primeFactors 901255
  , [11, 9539, 894119] @=? primeFactors 93819012551
  ]
