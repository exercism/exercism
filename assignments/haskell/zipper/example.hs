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
    btValue :: a,                 -- ^ Value
    btLeft  :: Maybe (BinTree a), -- ^ Left child
    btRight :: Maybe (BinTree a)  -- ^ Right child
} deriving (Eq, Show)

-- | A zipper for a binary tree.
data Zipper a = Z {
    zValue :: a,                 -- ^ Value of focus
    zLeft  :: Maybe (BinTree a), -- ^ Left child of focus
    zRight :: Maybe (BinTree a), -- ^ Right child of focus
    _zTrail :: ZipperTrail a     -- ^ Zipper trail, field name not used
} deriving (Eq, Show)

-- | A "trail" of a zipper.
--
-- This stores the history of how the focus was reached
-- and the value and other paths higher up in the tree.
data ZipperTrail a = L a (Maybe (BinTree a)) (ZipperTrail a) -- Left path taken
                   | R a (Maybe (BinTree a)) (ZipperTrail a) -- Right path taken
                   | T                                       -- Top level
  deriving (Eq, Show)

-- | Get a zipper focussed on the root node.
fromTree :: BinTree a -> Zipper a
fromTree (BT v l r) = Z v l r T

-- | Get the complete tree from a zipper.
toTree :: Zipper a -> BinTree a
toTree (Z v l r zt) = go (BT v l r) zt
  where
    go t (L pv pr pzt) = go (BT pv (Just t) pr) pzt
    go t (R pv pl pzt) = go (BT pv pl (Just t)) pzt
    go t T             = t

-- | Get the value of the focus node.
value :: Zipper a -> a
value = zValue 

-- | Get the left child of the focus node, if any.
left :: Zipper a -> Maybe (Zipper a)
left (Z _ Nothing _ _)               = Nothing
left (Z v (Just (BT lv ll lr)) r zt) = Just $ Z lv ll lr (L v r zt)

-- | Get the right child of the focus node, if any.
right :: Zipper a -> Maybe (Zipper a)
right (Z _ _ Nothing _)               = Nothing
right (Z v l (Just (BT rv rl rr)) zt) = Just $ Z rv rl rr (R v l zt)

-- | Get the parent of the focus node, if any.
up :: Zipper a -> Maybe (Zipper a)
up (Z v l r (L pv pr zt)) = Just (Z pv (Just (BT v l r)) pr zt)
up (Z v l r (R pv pl zt)) = Just (Z pv pl (Just (BT v l r)) zt)
up (Z _ _ _ T)            = Nothing

-- | Set the value of the focus node.
setValue :: a -> Zipper a -> Zipper a
setValue v z = z { zValue = v }

-- | Replace a left child tree.
setLeft :: Maybe (BinTree a) -> Zipper a -> Zipper a
setLeft t z = z { zLeft = t }

-- | Replace a right child tree.
setRight :: Maybe (BinTree a) -> Zipper a -> Zipper a
setRight t z = z { zRight = t } 
