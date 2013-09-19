import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import DNA (hammingDistance)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList hammingDistanceTests ]

hammingDistanceTests :: [Test]
hammingDistanceTests =
  [ testCase "no difference between empty strands" $
    0 @=? hammingDistance "" ""
  , testCase "no difference between identical strands" $
    0 @=? hammingDistance "GGACTGA" "GGACTGA"
  , testCase "complete hamming distance in small strand" $
    3 @=? hammingDistance "ACT" "GGA"
  , testCase "hamming distance in off by one strand" $
    19 @=? hammingDistance
    "GGACGGATTCTGACCTGGACTAATTTTGGGG"
    "AGGACGGATTCTGACCTGGACTAATTTTGGGG"
  , testCase "small hamming distance in middle somewhere" $
    1 @=? hammingDistance "GGACG" "GGTCG"
  , testCase "larger distance" $
    2 @=? hammingDistance "ACCAGGG" "ACTATGG"
  , testCase "ignores extra length on other strand when longer" $
    3 @=? hammingDistance "AAACTAGGGG" "AGGCTAGCGGTAGGAC"
  , testCase "ignores extra length on original strand when longer" $
    5 @=? hammingDistance "GACTACGGACAGGGTAGGGAAT" "GACATCGCACACC"
  , TestLabel "does not actually shorten original strand" $
    TestList $ map TestCase $
    [ 1 @=? hammingDistance "AGACAACAGCCAGCCGCCGGATT" "AGGCAA"
    , 1 @=? hammingDistance "AGACAACAGCCAGCCGCCGGATT" "AGGCAA"
    , 4 @=? hammingDistance
      "AGACAACAGCCAGCCGCCGGATT"
      "AGACATCTTTCAGCCGCCGGATTAGGCAA"
    , 1 @=? hammingDistance "AGACAACAGCCAGCCGCCGGATT" "AGG" ]
  ]