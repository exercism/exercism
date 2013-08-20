import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import Grains (square, total)

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = void $ runTestTT $ TestList
       [ TestList grainsTests ]

grainsTests :: [Test]
grainsTests =
  [ testCase "square 1" $
    1 @=? square 1
  , testCase "square 2" $
    2 @=? square 2
  , testCase "square 3" $
    4 @=? square 3
  , testCase "square 4" $
    8 @=? square 4
  , testCase "square 16" $
    32768 @=? square 16
  , testCase "square 32" $
    2147483648 @=? square 32
  , testCase "square 64" $
    9223372036854775808 @=? square 64
  , testCase "total grains" $
    18446744073709551615 @=? total
  ]
