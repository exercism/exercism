import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import SumOfMultiples (sumOfMultiples, sumOfMultiplesDefault)
testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = void $ runTestTT $ TestList
       [ TestList sumOfMultiplesTests ]

ints :: [Int] -> [Int]
ints = id

-- Note that the upper bound is not included in the result
sumOfMultiplesTests :: [Test]
sumOfMultiplesTests =
  [ testCase "1" $
    0 @=? sumOfMultiplesDefault 1
  , testCase "4" $
    3 @=? sumOfMultiplesDefault 4
  , testCase "10" $
    23 @=? sumOfMultiplesDefault 10
  , testCase "1000" $
    233168 @=? sumOfMultiplesDefault 1000
  , testCase "[7, 13, 17] 20" $
    51 @=? sumOfMultiples [7, 13, 17] 20
  , testCase "[43, 47] 10000" $
    2203160 @=? sumOfMultiples [43, 47] 10000
  ]
