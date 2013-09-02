module LinkedList ( LinkedList
                  , fromList, toList, reverseLinkedList
                  , datum, next, isNil, nil, new) where

data LinkedList a = Nil
                  | Cons { datum :: a
                         , next :: LinkedList a }

new :: a -> LinkedList a -> LinkedList a
new = Cons

nil :: LinkedList a
nil = Nil

fromList :: [a] -> LinkedList a
fromList [] = Nil
fromList (x:xs) = Cons x $ fromList xs

toList :: LinkedList a -> [a]
toList Nil = []
toList (Cons x xs) = x : toList xs

reverseLinkedList :: LinkedList a -> LinkedList a
reverseLinkedList = go Nil
  where go acc Nil = acc
        go acc (Cons x xs) = (go $! Cons x acc) xs

isNil :: LinkedList a -> Bool
isNil Nil = True
isNil _ = False
