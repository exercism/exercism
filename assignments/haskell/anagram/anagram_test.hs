import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import Anagram (anagramsFor)

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = void (runTestTT (TestList anagramTests))

anagramTests :: [Test]
anagramTests =
  [ testCase "no matches" $
    [] @=? anagramsFor "diaper" ["hello", "world", "zombies", "pants"]
  , testCase "detect simple anagram" $
    ["tan"] @=? anagramsFor "ant" ["tan", "stand", "at"]
  , testCase "does not confuse different duplicates" $
    [] @=? anagramsFor "galea" ["eagle"]
  , testCase "eliminate anagram subsets" $
    [] @=? anagramsFor "good" ["dog", "goody"]
  , testCase "detect anagram" $
    ["inlets"] @=? anagramsFor "listen" ["enlists", "google",
                                         "inlets", "banana"]
  , testCase "multiple anagrams" $
    ["gallery", "regally", "largely"] @=?
    anagramsFor "allergy" ["gallery", "ballerina", "regally", "clergy",
                           "largely", "leading"]
  , testCase "case insensitive anagrams" $
    ["Carthorse"] @=?
    anagramsFor "Orchestra" ["cashregister", "Carthorse", "radishes"]
  ]
