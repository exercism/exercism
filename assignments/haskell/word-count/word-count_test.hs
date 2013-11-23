import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Data.Map (fromList)
import WordCount (wordCount)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

wordCountTests :: [Test]
wordCountTests =
  [ testCase "count one word" $
    fromList [("word", 1)] @=? wordCount "word"
  , testCase "count one of each" $
    fromList [("one", 1), ("of", 1), ("each", 1)] @=? wordCount "one of each"
  , testCase "count multiple occurrences" $
    fromList [("one", 1), ("fish", 4), ("two", 1),
              ("red", 1), ("blue", 1)] @=?
    wordCount "one fish two fish red fish blue fish"
  , testCase "ignore punctuation" $
    fromList [("car", 1), ("carpet", 1), ("as", 1),
              ("java", 1), ("javascript", 1)] @=?
    wordCount "car : carpet as java : javascript!!&@$%^&"
  , testCase "include numbers" $
    fromList [("testing", 2), ("1", 1), ("2", 1)] @=?
    wordCount "testing, 1, 2 testing"
  , testCase "normalize case" $
    fromList [("go", 3)] @=? wordCount "go Go GO"
  , testCase "prefix punctuation" $
    fromList [("testing", 2), ("1", 1), ("2", 1)] @=?
    wordCount "!%%#testing, 1, 2 testing"
  , testCase "symbols are separators" $
    fromList [("hey", 1), ("my", 1), ("spacebar", 1),
              ("is", 1), ("broken", 1)] @=?
    wordCount "hey,my_spacebar_is_broken."
  ]

main :: IO ()
main = exitProperly (runTestTT (TestList wordCountTests))
