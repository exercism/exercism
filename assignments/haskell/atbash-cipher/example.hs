module Atbash (encode) where
import Data.Char (isDigit, toLower)
import Data.Maybe (mapMaybe)

cipher :: Char -> Maybe Char
cipher c | isDigit c              = Just c
         | lc >= 'a' && lc <= 'z' = Just rotated
         | otherwise              = Nothing
  where lc = toLower c
        rotated = toEnum $ fromEnum 'z' - fromEnum lc + fromEnum 'a'

spacedChunks :: Int -> String -> String
spacedChunks chunkSize = go 0
  where go n (c:cs) | n < chunkSize = c : go (succ n) cs
        go _ cs | null cs   = []
                | otherwise = ' ' : go 0 cs

encode :: String -> String
encode = spacedChunks 5 . mapMaybe cipher
