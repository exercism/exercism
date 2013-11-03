-- | Tools for parsing a SGF string.
module Sgf (
    parseSgf
) where

import           Control.Applicative
import           Data.Attoparsec.Combinator
import           Data.Attoparsec.Text
import           Data.Char (isUpper, isSpace)
import           Data.Map (Map)
import qualified Data.Map as Map
import           Data.Tree (Tree(..))
import           Data.Text (Text)
import qualified Data.Text as T

-- | A tree of nodes.
type SgfTree = Tree SgfNode

-- | A node is a property list, each key can only occur once.
--
-- Keys may have multiple values associated with them.
type SgfNode = Map Text [Text]

-- | Attempt to parse the given tree in SGF form.
--
-- Returns Nothing if the input wasn't valid SGF.
parseSgf :: Text -> Maybe SgfTree
parseSgf = either (const Nothing) Just . parseOnly tree

tree :: Parser SgfTree
tree = makeSgfTree <$> (char '(' *> many1 node)
                   <*> (many tree <* char ')')

node :: Parser SgfNode
node = char ';' *> (Map.fromList <$> many prop)

prop :: Parser (Text, [Text])
prop = (,) <$> (T.pack <$> many1 (satisfy isUpper)) <*> many1 val

-- | Parse a value, complete with brackets.
-- 
-- This is a bit tricky as there are escape sequences to take into account.
--
-- We'll use a simple folder with one bit of state: whether the last
val :: Parser Text
val = char '[' *> worker [] False
  where
    -- 'bs' = previous character was a backslash
    worker acc bs = do
        c <- anyChar
        case c of
            ']'  | not bs    -> return . T.pack . reverse $ acc
            '\\' | not bs    -> worker acc True
            '\n' | bs        -> worker acc False -- remove soft newline
            _    | isSpace c -> worker (' ' : acc) False
            _                -> worker (c : acc) False

-- | Create an 'SgfTree' from a list of nodes and subtrees.
--
-- This does the expansion of a ";n1;n2;n3(;n4)(;n5)" node list to
-- a tree structure with depth 4 where the n3 tree node has two children
-- and the n1 and n2 node each have one child.
makeSgfTree :: [SgfNode] -> [SgfTree] -> SgfTree
makeSgfTree [] _        = error "absurd" -- Can't happen due to 'many1 node' in 'tree'
makeSgfTree [n] trees   = Node n trees
makeSgfTree (h:t) trees = Node h [makeSgfTree t trees]
