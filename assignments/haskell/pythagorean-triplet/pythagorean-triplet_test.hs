import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Triplet (mkTriplet, isPythagorean, pythagoreanTriplets)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList tripletTests ]

tripletTests :: [Test]
tripletTests =
  [ testCase "isPythagorean" $ do
    True @=? isPythagorean (mkTriplet 3 4 5)
    True @=? isPythagorean (mkTriplet 3 5 4)
    True @=? isPythagorean (mkTriplet 4 3 5)
    True @=? isPythagorean (mkTriplet 4 5 3)
    True @=? isPythagorean (mkTriplet 5 3 4)
    True @=? isPythagorean (mkTriplet 5 4 3)
    False @=? isPythagorean (mkTriplet 3 3 3)
    False @=? isPythagorean (mkTriplet 5 6 7)
  , testCase "pythagoreanTriplets" $ do
    [mkTriplet 3 4 5, mkTriplet 6 8 10] @=? pythagoreanTriplets 1 10
    [mkTriplet 12 16 20] @=? pythagoreanTriplets 11 20
    [mkTriplet 57 76 95, mkTriplet 60 63 87] @=? pythagoreanTriplets 56 95
  ]
