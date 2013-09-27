import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Allergies (Allergen(..), isAllergicTo, allergies)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList allergiesTests ]

allergiesTests :: [Test]
allergiesTests =
  [ testCase "no allergies at all" $
    [] @=? allergies 0
  , testCase "allergic to just eggs" $
    [Eggs] @=? allergies 1
  , testCase "allergic to just peanuts" $
    [Peanuts] @=? allergies 2
  , testCase "allergic to just strawberries" $
    [Strawberries] @=? allergies 8
  , testCase "allergic to eggs and peanuts" $
    [Eggs, Peanuts] @=? allergies 3
  , testCase "allergic to more than eggs but not peanuts" $
    [Eggs, Shellfish] @=? allergies 5
  , testCase "allergic to lots of stuff" $
    [Strawberries, Tomatoes, Chocolate, Pollen, Cats] @=? allergies 248
  , testCase "allergic to everything" $
    [ Eggs, Peanuts, Shellfish, Strawberries, Tomatoes, Chocolate
    , Pollen, Cats ] @=? allergies 255
  , testCase "no allergies means not allergic" $ do
    False @=? isAllergicTo Peanuts 0
    False @=? isAllergicTo Cats 0
    False @=? isAllergicTo Strawberries 0
  , testCase "is allergic to eggs" $
    True @=? isAllergicTo Eggs 1
  , testCase "allergic to eggs in addition to other stuff" $
    True @=? isAllergicTo Eggs 5
  , testCase "ignore non allergen score parts" $
    [ Eggs, Shellfish, Strawberries, Tomatoes, Chocolate
    , Pollen, Cats ] @=? allergies 509
  ]
