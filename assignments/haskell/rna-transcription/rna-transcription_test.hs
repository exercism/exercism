import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import DNA (toRNA)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

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
main = exitProperly (runTestTT (TestList toRNATests))
