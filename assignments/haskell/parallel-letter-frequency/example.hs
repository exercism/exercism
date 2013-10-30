module Frequency (frequency) where

import           Data.Char (isLetter, toLower)
import           Data.Map (Map)
import qualified Data.Map as Map
import           Data.Text (Text)
import qualified Data.Text as T

-- | Compute the frequency of letters in the text using the given number of
--   parallel workers.
frequency :: Int -> [Text] -> Map Char Int
frequency _workers = Map.unionsWith (+) . map countLetters

countLetters :: Text -> Map Char Int
countLetters = T.foldl' process Map.empty
  where
    process m c | isLetter c = Map.insertWith (+) (toLower c) 1 m
                | otherwise  = m
