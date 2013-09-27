module Hexadecimal (hexToInt) where

digitToInt :: Char -> Maybe Int
digitToInt c
  | c >= '0' && c <= '9' = Just $ n - fromEnum '0'
  | c >= 'a' && c <= 'f' = Just $ n - fromEnum 'a' + 10
  | c >= 'A' && c <= 'F' = Just $ n - fromEnum 'A' + 10
  | otherwise            = Nothing
  where n = fromEnum c

hexToInt :: String -> Int
hexToInt = go 0
  where
    go acc (c:cs) = case digitToInt c of
      Just n -> (go $! acc * 16 + n) cs
      _      -> 0
    go acc [] = acc
