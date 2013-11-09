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
data BinTree a = BT a                   -- ^ Value
                    (Maybe (BinTree a)) -- ^ Left child
                    (Maybe (BinTree a)) -- ^ Right child
  deriving (Eq, Show)

-- | A zipper for a binary tree.
data Zipper a = Z a                     -- ^ Value of focus
                  (Maybe (BinTree a))   -- ^ Left child of focus
                  (Maybe (BinTree a))   -- ^ Right child of focus
                  (ZipperTrail a)       -- ^ Zipper trail
  deriving (Eq, Show)

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
value (Z v _ _ _) = v

-- | Get the left child of the focus node, if any.
left :: Zipper a -> Maybe (Zipper a)
left (Z _ Nothing _ _)               = Nothing
left (Z v (Just (BT lv ll lr)) r zt) = Just $ Z lv ll lr (L v r zt)

-- | Get the right child of the focus node, if any.
right :: Zipper a -> Maybe (Zipper a)
right (Z _ _ Nothing _)               = Nothing
right (Z v l (Just (BT rv rl rr)) zt) = Just $ Z rv rl rr (R v l zt)

-- | Get the parent of the focus node.
--
-- If the focus node is the root node doesn't move the zipper.
up :: Zipper a -> Zipper a
up (Z v l r (L pv pr zt)) = Z pv (Just (BT v l r)) pr zt
up (Z v l r (R pv pl zt)) = Z pv pl (Just (BT v l r)) zt
up z@(Z _ _ _ T)          = z

-- | Set the value of the focus node.
setValue :: a -> Zipper a -> Zipper a
setValue v (Z _ l r zt) = Z v l r zt

-- | Replace a left child tree.
setLeft :: Maybe (BinTree a) -> Zipper a -> Zipper a
setLeft t (Z v _ r zt)  = Z v t r zt

-- | Replace a right child tree.
setRight :: Maybe (BinTree a) -> Zipper a -> Zipper a
setRight t (Z v l _ zt)  = Z v l t zt
