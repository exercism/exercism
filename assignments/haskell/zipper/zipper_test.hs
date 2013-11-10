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

empty :: Maybe (BinTree a)
empty = Nothing

bt :: Int -> Maybe (BinTree Int) -> Maybe (BinTree Int) -> Maybe (BinTree Int)
bt v l r = Just (BT v l r)

leaf :: Int -> Maybe (BinTree Int)
leaf v = bt v Nothing Nothing

t1, t2, t3, t4 :: BinTree Int
t1 = BT 1 (bt 2 empty    (leaf 3)) (leaf 4)
t2 = BT 1 (bt 5 empty    (leaf 3)) (leaf 4)
t3 = BT 1 (bt 2 (leaf 5) (leaf 3)) (leaf 4)
t4 = BT 1 (leaf 2)                 (leaf 4)

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
