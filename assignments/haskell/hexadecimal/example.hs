module Hexadecimal (hexToInt) where

digitToInt :: Char -> Int
digitToInt c
  | c >= '0' && c <= '9' = n - fromEnum '0'
  | c >= 'a' && c <= 'f' = n - fromEnum 'a' + 10
  | c >= 'A' && c <= 'F' = n - fromEnum 'A' + 10
  | otherwise            = error "not a digit"
  where n = fromEnum c

isHexDigit :: Char -> Bool
isHexDigit c = (c >= '0' && c <= '9') ||
               (c >= 'a' && c <= 'f') ||
               (c >= 'A' && c <= 'F')

hexToInt :: String -> Int
hexToInt = go 0
  where
    go acc (c:cs) | isHexDigit c = let acc' = acc * 16 + digitToInt c
                                   in acc' `seq` go acc' cs
                  | otherwise    = 0
    go acc [] = acc
