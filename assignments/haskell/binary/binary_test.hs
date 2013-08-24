import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import Binary (toDecimal)

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = void $ runTestTT $ TestList
       [ TestList binaryTests ]

binaryTests :: [Test]
binaryTests = map TestCase
  [ 1 @=? toDecimal "1"
  , 2 @=? toDecimal "10"
  , 3 @=? toDecimal "11"
  , 4 @=? toDecimal "100"
  , 9 @=? toDecimal "1001"
  , 26 @=? toDecimal "11010"
  , 1128 @=? toDecimal "10001101000"
  , 0 @=? toDecimal "carrot"
  ]
