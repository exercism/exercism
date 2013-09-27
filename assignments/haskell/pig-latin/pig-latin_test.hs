import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import PigLatin (translate)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList pigLatinTests ]

pigLatinTests :: [Test]
pigLatinTests =
  [ testCase "beginning with vowels" $ do
    "appleay" @=? translate "apple"
    "earay" @=? translate "ear"
  , testCase "beginning with single letter consonant clusters" $ do
    "igpay" @=? translate "pig"
    "oalakay" @=? translate "koala"
    "atqay"   @=? translate "qat"
  , testCase "beginning with multiple letter consonant clusters" $ do
    "airchay" @=? translate "chair"
    "erapythay" @=? translate "therapy"
    "ushthray" @=? translate "thrush"
    "oolschay" @=? translate "school"
  , testCase "consonant clusters with qu" $ do
    "eenquay" @=? translate "queen"
    "aresquay" @=? translate "square"
  , testCase "phrase" $
    "ickquay astfay unray" @=? translate "quick fast run"
  ]
