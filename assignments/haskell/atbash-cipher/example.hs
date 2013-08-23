module Atbash (encode) where
import Data.Char (isDigit, toLower)
import Data.Maybe (mapMaybe)
import Data.List (intercalate)
import Data.List.Split (chunksOf)

cipher :: Char -> Maybe Char
cipher c | isDigit c              = Just c
         | lc >= 'a' && lc <= 'z' = Just rotated
         | otherwise              = Nothing
  where lc = toLower c
        rotated = toEnum $ fromEnum 'z' - fromEnum lc + fromEnum 'a'

encode :: String -> String
encode = intercalate " " . chunksOf 5 . mapMaybe cipher
