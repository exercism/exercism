module WordCount (wordCount) where
import Data.Char (toLower, isAlphaNum)
import Data.Map (Map, fromListWith)

-- Generalized version of Data.List.words
wordsBy :: (Char -> Bool) -> String -> [String]
wordsBy f s = case dropWhile f s of
  "" -> []
  s' -> w : wordsBy f s''
        where (w, s'') = break f s'


wordCount :: String -> Map String Int
wordCount = fromListWith (+) . map pair . wordsBy (not . isAlphaNum)
  where pair word = (map toLower word, 1)