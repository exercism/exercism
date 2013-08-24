import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import Data.Map (fromList)
import WordCount (wordCount)

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
  ]

main :: IO ()
main = void (runTestTT (TestList wordCountTests))
