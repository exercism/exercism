import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import WordProblem (answer)

-- This is a perfect opportunity to learn some Attoparsec or Parsec!

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList answerTests ]

answerTests :: [Test]
answerTests =
  [ testCase "1 + 1" $
    Just 2 @=? answer "What is 1 plus 1?"
  , testCase "53 + 2" $
    Just 55 @=? answer "What is 53 plus 2?"
  , testCase "(-1) + (-10)" $
    Just (-11) @=? answer "What is -1 plus -10?"
  , testCase "123 + 45678" $
    Just 45801 @=? answer "What is 123 plus 45678?"
  , testCase "4 - (-12)" $
    Just 16 @=? answer "What is 4 minus -12?"
  , testCase "(-3) * 25" $
    Just (-75) @=? answer "What is -3 multiplied by 25?"
  , testCase "33 / (-3)" $
    Just (-11) @=? answer "What is 33 divided by -3?"
  , testCase "1 + 1 + 1" $
    Just 3 @=? answer "What is 1 plus 1 plus 1?"
  , testCase "1 + 5 - (-2)" $
    Just 8 @=? answer "What is 1 plus 5 minus -2?"
  , testCase "20 - 4 - 13" $
    Just 3 @=? answer "What is 20 minus 4 minus 13?"
  , testCase "17 - 6 + 3" $
    Just 14 @=? answer "What is 17 minus 6 plus 3?"
  , testCase "2 * (-2) * 3" $
    Just (-12) @=? answer "What is 2 multiplied by -2 multiplied by 3?"
  , testCase "((-3) + 7) * -2" $
    Just (-8) @=? answer "What is -3 plus 7 multiplied by -2?"
  , testCase "(-12) / 2 / (-3)" $
    Just 2 @=? answer "What is -12 divided by 2 divided by -3?"
  , testCase "What is 53 cubed?" $
    Nothing @=? answer "What is 53 cubed?"
  , testCase "Who is the president of the United States?" $
    Nothing @=? answer "Who is the president of the United States?"
  ]
