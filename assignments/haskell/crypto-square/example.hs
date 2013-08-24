module CryptoSquare ( normalizePlaintext
                    , squareSize
                    , plaintextSegments
                    , ciphertext
                    , normalizeCiphertext ) where

import Data.Char (isAlphaNum, toLower)
import Data.List (intercalate)
import Data.List.Split (chunksOf)

everyNth :: Int -> String -> String
everyNth = (map head .) . chunksOf

squareSize :: String -> Int
squareSize = ceiling . (sqrt :: Double -> Double) . fromIntegral . length

normalizePlaintext :: String -> String
normalizePlaintext = map toLower . filter isAlphaNum

plaintextSegments :: String -> [String]
plaintextSegments s = chunksOf (squareSize text) text
  where text = normalizePlaintext s

cipherSegments :: String -> [String]
cipherSegments s = map (everyNth cols . flip drop s) [0 .. pred cols]
  where cols = squareSize s

ciphertext :: String -> String
ciphertext = concat . cipherSegments . normalizePlaintext

normalizeCiphertext :: String -> String
normalizeCiphertext = intercalate " " . chunksOf 5 . ciphertext
