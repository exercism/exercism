import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import Bob (responseFor)

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

test_respondsToSomething :: Assertion
test_respondsToSomething =
  "Whatever." @=? responseFor "Tom-ay-to, tom-aaaah-to."

test_respondsToShouts :: Assertion
test_respondsToShouts =
  "Woah, chill out!" @=? responseFor "WATCH OUT!"

test_respondsToQuestions :: Assertion
test_respondsToQuestions =
  "Sure." @=? responseFor "Does this cryogenic chamber make me look fat?"

test_respondsToForcefulTalking :: Assertion
test_respondsToForcefulTalking =
  "Whatever." @=? responseFor "Let's go make out behind the gym!"

test_respondsToAcronyms :: Assertion
test_respondsToAcronyms =
  "Whatever." @=? responseFor "It's OK if you don't want to go to the DMV."

test_respondsToForcefulQuestions :: Assertion
test_respondsToForcefulQuestions =
  "Woah, chill out!" @=? responseFor "WHAT THE HELL WERE YOU THINKING?"

test_respondsToShoutingWithSpecialCharacters :: Assertion
test_respondsToShoutingWithSpecialCharacters =
  "Woah, chill out!" @=? responseFor (
    "ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!")

test_respondsToShoutingNumbers :: Assertion
test_respondsToShoutingNumbers =
  "Woah, chill out!" @=? responseFor "1, 2, 3 GO!"

test_respondsToShoutingWithNoExclamationMark :: Assertion
test_respondsToShoutingWithNoExclamationMark =
  "Woah, chill out!" @=? responseFor "I HATE YOU"

test_respondsToStatementContainingQuestionMark :: Assertion
test_respondsToStatementContainingQuestionMark =
  "Whatever." @=? responseFor "Ending with ? means a question."

test_respondsToSilence :: Assertion
test_respondsToSilence =
  "Fine. Be that way!" @=? responseFor ""

test_respondsToProlongedSilence :: Assertion
test_respondsToProlongedSilence =
  "Fine. Be that way!" @=? responseFor "    "

test_respondsToNonLettersWithQuestion :: Assertion
test_respondsToNonLettersWithQuestion =
  "Sure." @=? responseFor ":) ?"

test_respondsToMultipleLineQuestions :: Assertion
test_respondsToMultipleLineQuestions =
  "Whatever." @=? responseFor "\nDoes this cryogenic chamber make me look fat? \nno"

test_respondsToOtherWhitespace :: Assertion
test_respondsToOtherWhitespace =
  "Fine. Be that way!" @=? responseFor "\n\r \t\v\xA0\x2002" -- \xA0 No-break space, \x2002 En space

respondsToTests :: [Test]
respondsToTests =
  [ testCase "something" test_respondsToSomething
  , testCase "shouts" test_respondsToShouts
  , testCase "questions" test_respondsToQuestions
  , testCase "forceful talking" test_respondsToForcefulTalking
  , testCase "acronyms" test_respondsToAcronyms
  , testCase "forceful questions" test_respondsToForcefulQuestions
  , testCase "shouting with special characters"
    test_respondsToShoutingWithSpecialCharacters
  , testCase "shouting numbers" test_respondsToShoutingNumbers
  , testCase "shouting with no exclamation mark"
    test_respondsToShoutingWithNoExclamationMark
  , testCase "statement containing question mark"
    test_respondsToStatementContainingQuestionMark
  , testCase "silence" test_respondsToSilence
  , testCase "prolonged silence" test_respondsToProlongedSilence
  , testCase "questioned nonsence" test_respondsToNonLettersWithQuestion
  , testCase "multiple-line statement containing question mark"
    test_respondsToMultipleLineQuestions
  , testCase "all whitespace is silence" test_respondsToOtherWhitespace
  ]

main :: IO ()
main = void (runTestTT (TestList respondsToTests))
