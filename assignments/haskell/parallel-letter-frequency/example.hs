module Frequency (frequency) where

import           Control.Parallel.Strategies (using, parListChunk, rdeepseq)
import           Data.Char (isLetter, toLower)
import           Data.Map (Map)
import qualified Data.Map as Map
import           Data.Ratio ((%))
import           Data.Text (Text)
import qualified Data.Text as T

-- | Compute the frequency of letters in the text using the given number of
--   parallel workers.
frequency :: Int -> [Text] -> Map Char Int
frequency workers texts = 
    let chunkSize = ceiling (length texts % workers)
        freqs = map countLetters texts `using` parListChunk chunkSize rdeepseq
    in Map.unionsWith (+) freqs

countLetters :: Text -> Map Char Int
countLetters = T.foldl' process Map.empty
  where
    process m c | isLetter c = Map.insertWith (+) (toLower c) 1 m
                | otherwise  = m
