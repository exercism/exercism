import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import Hexadecimal (hexToInt)

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = void $ runTestTT $ TestList
       [ TestList hexTests ]

hexTests :: [Test]
hexTests = map TestCase
  [ 1 @=? hexToInt "1"
  , 12 @=? hexToInt "c"
  , 16 @=? hexToInt "10"
  , 175 @=? hexToInt "af"
  , 256 @=? hexToInt "100"
  , 105166 @=? hexToInt "19ace"
  , 0 @=? hexToInt "carrot"
  , 0 @=? hexToInt "000000"
  , 16777215 @=? hexToInt "ffffff"
  , 16776960 @=? hexToInt "ffff00"
  ]