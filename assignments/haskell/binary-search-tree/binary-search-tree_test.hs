import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import BST (bstLeft, bstRight, bstValue, singleton, insert, fromList, toList)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList bstTests ]

int4 :: Int
int4 = 4

bstTests :: [Test]
bstTests =
  [ testCase "data is retained" $
    4 @=? bstValue (singleton int4)
  , testCase "inserting less" $ do
    let t = insert 2 (singleton int4)
    4 @=? bstValue t
    Just 2 @=? bstValue `fmap` bstLeft t
  , testCase "inserting same" $ do
    let t = insert 4 (singleton int4)
    4 @=? bstValue t
    Just 4 @=? bstValue `fmap` bstLeft t
  , testCase "inserting right" $ do
    let t = insert 5 (singleton int4)
    4 @=? bstValue t
    Just 5 @=? bstValue `fmap` bstRight t
  , testCase "complex tree" $ do
    let t = fromList [int4, 2, 6, 1, 3, 7, 5]
    4 @=? bstValue t
    Just 2 @=? bstValue `fmap` bstLeft t
    Just 1 @=? bstValue `fmap` (bstLeft t >>= bstLeft)
    Just 3 @=? bstValue `fmap` (bstLeft t >>= bstRight)
    Just 6 @=? bstValue `fmap` bstRight t
    Just 5 @=? bstValue `fmap` (bstRight t >>= bstLeft)
    Just 7 @=? bstValue `fmap` (bstRight t >>= bstRight)
  , testCase "iterating one element" $
    [4] @=? toList (singleton int4)
  , testCase "iterating over smaller element" $
    [2, 4] @=? toList (fromList [int4, 2])
  , testCase "iterating over larger element" $
    [4, 5] @=? toList (fromList [int4, 5])
  , testCase "iterating over complex tree" $
    [1..7] @=? toList (fromList [int4, 2, 1, 3, 6, 7, 5])
  ]