module Hexadecimal (hexToInt) where

import Numeric (readHex)

hexToInt :: String -> Int
hexToInt s = case readHex s of
  [(n, "")] -> n
  _         -> 0