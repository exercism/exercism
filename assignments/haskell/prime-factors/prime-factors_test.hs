import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import PrimeFactors (primeFactors)

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = void $ runTestTT $ TestList
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
