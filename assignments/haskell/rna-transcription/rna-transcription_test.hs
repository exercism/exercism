import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import DNA (toRNA)

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

toRNATests :: [Test]
toRNATests =
  [ testCase "transcribes cytidine unchanged" $
    "C" @=? toRNA "C"
  , testCase "transcribes guanosine unchanged" $
    "G" @=? toRNA "G"
  , testCase "transcribes adenosine unchanged" $
    "A" @=? toRNA "A"
  , testCase "transcribes thymidine to uracil" $
    "U" @=? toRNA "T"
  , testCase "transcribes all occurrences of thymidine to uracil" $
    "ACGUGGUCUUAA" @=? toRNA "ACGTGGTCTTAA"
  ]

main :: IO ()
main = void (runTestTT (TestList toRNATests))
