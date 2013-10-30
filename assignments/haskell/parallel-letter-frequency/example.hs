module Frequency (frequency) where

import           Control.Monad.Par (IVar, Par)
import qualified Control.Monad.Par as Par
import           Data.Char (isLetter, toLower)
import           Data.List.Split (chunksOf)
import           Data.Map (Map)
import qualified Data.Map as Map
import           Data.Text (Text)
import qualified Data.Text as T

-- | Compute the frequency of letters in the text using the given number of
--   parallel workers.
frequency :: Int -> [Text] -> Map Char Int
frequency workers texts = Par.runPar $ do
    let chunks = chunksOf workers texts
    ivars <- mapM (\_ -> Par.new) chunks
    mapM_ (Par.fork . work) $ zip chunks ivars
    freqs <- mapM Par.get ivars
    return $ Map.unionsWith (+) freqs

work :: ([Text], IVar (Map Char Int)) -> Par ()
work (texts, ivar) = Par.put ivar .  Map.unionsWith (+) . map countLetters $ texts

countLetters :: Text -> Map Char Int
countLetters = T.foldl' process Map.empty
  where
    process m c | isLetter c = Map.insertWith (+) (toLower c) 1 m
                | otherwise  = m
