module Zipper (
    BinTree(..),
    Zipper,

    fromTree,
    toTree,

    value,
    left,
    right,
    up,

    setValue,
    setLeft,
    setRight
) where

-- | A binary tree.
data BinTree a = BT { 
    btValue :: a                 -- ^ Value
  , btLeft  :: Maybe (BinTree a) -- ^ Left child
  , btRight :: Maybe (BinTree a) -- ^ Right child
} deriving (Eq, Show)

-- | A zipper for a binary tree.
data Zipper a -- Complete this definition

-- | Get a zipper focussed on the root node.
fromTree :: BinTree a -> Zipper a
fromTree = undefined

-- | Get the complete tree from a zipper.
toTree :: Zipper a -> BinTree a
toTree = undefined

-- | Get the value of the focus node.
value :: Zipper a -> a
value = undefined 

-- | Get the left child of the focus node, if any.
left :: Zipper a -> Maybe (Zipper a)
left = undefined

-- | Get the right child of the focus node, if any.
right :: Zipper a -> Maybe (Zipper a)
right = undefined

-- | Get the parent of the focus node.
--
-- If the focus node is the root node doesn't move the zipper.
up :: Zipper a -> Zipper a
up = undefined

-- | Set the value of the focus node.
setValue :: a -> Zipper a -> Zipper a
setValue = undefined

-- | Replace a left child tree.
setLeft :: Maybe (BinTree a) -> Zipper a -> Zipper a
setLeft = undefined 

-- | Replace a right child tree.
setRight :: Maybe (BinTree a) -> Zipper a -> Zipper a
setRight = undefined
