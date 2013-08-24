module WordCount (wordCount) where
import Data.Char (toLower, isAlphaNum)
import Data.Map (Map, fromListWith)
import Data.List.Split (wordsBy)

wordCount :: String -> Map String Int
wordCount = fromListWith (+) . map pair . wordsBy (not . isAlphaNum)
  where pair word = (map toLower word, 1)