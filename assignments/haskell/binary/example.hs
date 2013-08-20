module Binary (toDecimal) where
import Data.Maybe (mapMaybe)
import Data.List (foldl')
import Data.Bits (shiftL, (.|.))
toDecimal :: String -> Int
toDecimal = foldl' go 0 . mapMaybe toDigit
  where
    go n bit = shiftL n 1 .|. bit
    toDigit '0' = Just 0
    toDigit '1' = Just 1
    toDigit _   = Nothing
