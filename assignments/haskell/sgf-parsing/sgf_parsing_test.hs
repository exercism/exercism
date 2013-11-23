{-# LANGUAGE OverloadedStrings #-}

import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Tree
import Data.Text (Text)
import Sgf (parseSgf)

-- The Sgf module should export a parseSgf module with the following
-- signature:
--
-- parseSgf :: Text -> Maybe (Tree (Map Text [Text]))
--
-- You may find it useful to copy the type definitions for SgfTree and
-- SgfNode from this file.
--
-- The parsec library is part of the Haskell Platform. Please use it to
-- your advantage.

-- | A tree of nodes.
type SgfTree = Tree SgfNode

-- | A node is a property list, each key can only occur once.
--
-- Keys may have multiple values associated with them.
type SgfNode = Map Text [Text]

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

-- | Feed the input to 'parseSgf' and check that the result matches what's
--   expected.
tps :: Text -> Maybe SgfTree -> Test
tps input expected =
    let label = "parse " ++ show input
    in testCase label (expected @=? parseSgf input)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList sgfParsingTests ]

t :: [(Text, [Text])] -> [SgfTree] -> SgfTree
t n = Node (Map.fromList n)

-- Tree, single child
ts :: [(Text, [Text])] -> SgfTree -> SgfTree
ts n tr = Node (Map.fromList n) [tr]

-- Tree, no children
tn :: [(Text, [Text])] -> SgfTree
tn n = Node (Map.fromList n) []

sgfParsingTests :: [Test]
sgfParsingTests =
  [ tps "" $
    Nothing 
  , tps "()" $
    Nothing
  , tps ";" $
    Nothing
  , tps "(;)" $
    Just $ tn []
  , tps "(;A[B])" $
    Just $ tn [("A", ["B"])]
  , tps "(;a)" $
    Nothing
  , tps "(;a[b])" $
    Nothing
  , tps "(;Aa[b])" $
    Nothing
  , tps "(;A[B];B[C])" $ 
    Just $ ts [("A", ["B"])] (tn [("B", ["C"])])
  , tps "(;A[B](;B[C])(;C[D]))" $ 
    Just $ t [("A", ["B"])]
        [ tn [("B", ["C"])]
        , tn [("C", ["D"])]
        ]
  , tps "(;A[b][c][d])" $
    Just $ tn [("A", ["b", "c", "d"])]
  , tps "(;A[\\]b\nc\\\nd\t\te\\\\ \\\n\\]])" $
    Just $ tn [("A", ["]b cd  e\\ ]"])]
  ]
