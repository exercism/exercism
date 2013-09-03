{-# LANGUAGE TupleSections #-}
module Deque (Deque, mkDeque, push, pop, shift, unshift) where

import Control.Applicative ((<$>), (<*>))
import Control.Concurrent.STM ( STM, TMVar, takeTMVar, putTMVar, readTMVar
                              , swapTMVar, atomically, newEmptyTMVar, newTMVar)
import Control.Monad (void)

data Node a = Node { nodeValue :: a
                   , nodeNext :: TMVar (Node a)
                   , nodePrev :: TMVar (Node a) }

instance Eq (Node a) where
  (Node _ na pa) == (Node _ nb pb) = (na == nb) && (pa == pb)

newtype Deque a = Deque { unDeque :: TMVar (Maybe (Node a)) }
                deriving (Eq)

mkNode :: a -> STM (Node a)
mkNode a = Node a <$> newEmptyTMVar <*> newEmptyTMVar

mkDeque :: IO (Deque a)
mkDeque = atomically $ Deque <$> newTMVar Nothing

mkRoot :: a -> STM (Node a)
mkRoot a = do
  n <- mkNode a
  putTMVar (nodeNext n) n
  putTMVar (nodePrev n) n
  return n

deleteNode :: Node a -> STM (Maybe (Node a))
deleteNode n = do
  prev <- takeTMVar (nodePrev n)
  next <- takeTMVar (nodeNext n)
  if n == prev
    then return Nothing
    else do
    void $ swapTMVar (nodeNext prev) next
    void $ swapTMVar (nodePrev next) prev
    return $ Just next

mkBefore :: Node a -> a -> STM (Node a)
mkBefore front a = do
  n <- mkNode a
  back <- swapTMVar (nodePrev front) n
  void $ swapTMVar (nodeNext back) n
  putTMVar (nodeNext n) front
  putTMVar (nodePrev n) back
  return n

withDeque :: STM (Maybe (Node a), b)
             -> (Node a -> STM (Maybe (Node a), b))
             -> Deque a
             -> IO b
withDeque def go d = atomically $ do
  let var = unDeque d
  (mFront, r) <- takeTMVar var >>= maybe def go
  putTMVar var mFront
  return r

voidreturn :: STM a -> STM (a, ())
voidreturn = fmap (, ())

push :: Deque a -> a -> IO ()
push d a = withDeque (voidreturn $ Just <$> mkRoot a) (voidreturn . go) d
  where go front = mkBefore front a >> return (Just front)

unshift :: Deque a -> a -> IO ()
unshift d a = withDeque (voidreturn $ Just <$> mkRoot a) (voidreturn . go) d
  where go front = Just <$> mkBefore front a

pop :: Deque a -> IO (Maybe a)
pop = withDeque (return (Nothing, Nothing)) go
  where go front = do
          back <- readTMVar (nodePrev front)
          (, Just (nodeValue back)) <$> deleteNode back

shift :: Deque a -> IO (Maybe a)
shift = withDeque (return (Nothing, Nothing)) go
  where go front = (, Just (nodeValue front)) <$> deleteNode front