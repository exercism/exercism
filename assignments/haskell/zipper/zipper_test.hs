import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Data.Maybe (fromJust)
import Zipper

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList zipperTests ]

t1 :: BinTree Int
t1 = BT 1
        (Just (BT 2
                  Nothing
                  (Just (BT 3 Nothing Nothing))))
        (Just (BT 4 Nothing Nothing))

t2 :: BinTree Int
t2 = BT 1
        (Just (BT 5
                  Nothing
                  (Just (BT 3 Nothing Nothing))))
        (Just (BT 4 Nothing Nothing))

t3 :: BinTree Int
t3 = BT 1
        (Just (BT 2
                  (Just (BT 5 Nothing Nothing))
                  (Just (BT 3 Nothing Nothing))))
        (Just (BT 4 Nothing Nothing))

t4 :: BinTree Int
t4 = BT 1
        (Just (BT 2 Nothing Nothing))
        (Just (BT 4 Nothing Nothing))

zipperTests :: [Test]
zipperTests =
  [ testCase "data is retained" $
    t1 @=? toTree (fromTree t1)
  , testCase "left, right and value" $
    3 @=? (value . fromJust . right . fromJust . left . fromTree $ t1)
  , testCase "dead end" $
    Nothing @=? (left . fromJust . left . fromTree $ t1)
  , testCase "tree from deep focus" $
    t1 @=? (toTree . fromJust . right . fromJust . left . fromTree $ t1)
  , testCase "setValue" $
    t2 @=? (toTree . setValue 5 . fromJust . left . fromTree $ t1)
  , testCase "setLeft with Just" $
    t3 @=? (toTree . setLeft (Just (BT 5 Nothing Nothing)) . fromJust . left . fromTree $ t1)
  , testCase "setRight with Nothing" $
    t4 @=? (toTree . setRight Nothing . fromJust . left . fromTree $ t1)
  ]
