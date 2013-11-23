import Test.HUnit (Assertion, (@=?), runTestTT, assertFailure, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import DNA (count, nucleotideCounts)
import Data.Map (fromList)
import qualified Control.Exception as E

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

assertError :: String -> a -> IO ()
assertError err f =
  do r <- E.try (E.evaluate f)
     case r of
       Left (E.ErrorCall s) | err == s -> return ()
       _ -> assertFailure ("expecting error " ++ show err)

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList countTests
       , TestList nucleotideCountTests]

countTests :: [Test]
countTests =
  [ testCase "empty dna strand has no adenosine" $
    0 @=? count 'A' ""
  , testCase "repetitive cytidine gets counted" $
    5 @=? count 'C' "CCCCC"
  , testCase "counts only thymidine" $
    1 @=? count 'T' "GGGGGTAACCCGG"
  , testCase "dna has no uracil" $
    0 @=? count 'U' "GATTACA"
  , testCase "validates nucleotides" $
    assertError "invalid nucleotide 'X'" $ count 'X' "GACT"
  ]

nucleotideCountTests :: [Test]
nucleotideCountTests =
  [ testCase "empty dna strand has no nucleotides" $
    fromList [('A', 0), ('T', 0), ('C', 0), ('G', 0)] @=?
    nucleotideCounts ""
  , testCase "repetitive-sequence-has-only-guanosine" $
    fromList [('A', 0), ('T', 0), ('C', 0), ('G', 8)] @=?
    nucleotideCounts "GGGGGGGG"
  , testCase "counts all nucleotides" $
    fromList [('A', 20), ('T', 21), ('C', 12), ('G', 17)] @=?
    nucleotideCounts ("AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAA" ++
                      "GAGTGTCTGATAGCAGC")
  ]
