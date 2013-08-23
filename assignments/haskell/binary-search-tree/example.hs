module BST ( BST, bstLeft, bstRight, bstValue,
             singleton, insert, fromList, toList
           ) where
import Data.List (foldl')
import Control.Applicative ((<$>), (<|>))
import Data.Monoid ((<>))
import Data.Maybe (fromJust)

data BST a = Node { bstValue :: a
                  , bstLeft :: Maybe (BST a)
                  , bstRight :: Maybe (BST a) }
             deriving (Show, Eq)

singleton :: Ord a => a -> BST a
singleton x = Node x Nothing Nothing

insert :: Ord a => a -> BST a -> BST a
insert x n =
  if bstValue n >= x
  then n { bstLeft  = insert x <$> bstLeft  n <|> Just (singleton x) }
  else n { bstRight = insert x <$> bstRight n <|> Just (singleton x) }

fromList :: Ord a => [a] -> BST a
fromList (x:xs) = foldl' (flip insert) (singleton x) xs
fromList [] = error "tree must not be empty"

toList :: BST a -> [a]
toList (Node x l r) = fromJust $ (toList <$> l) <> Just [x] <> (toList <$> r)