module CryptoSquare ( normalizePlaintext
                    , squareSize
                    , plaintextSegments
                    , ciphertext
                    , normalizeCiphertext ) where

import Data.Char (isAlphaNum, toLower)
import Data.List (intercalate)

chunk :: Int -> [a] -> [[a]]
chunk _ [] = []
chunk n xs = ys : chunk n zs
  where (ys,zs) = splitAt n xs

everyNth :: Int -> String -> String
everyNth = (map head .) . chunk

squareSize :: String -> Int
squareSize = ceiling . (sqrt :: Double -> Double) . fromIntegral . length

normalizePlaintext :: String -> String
normalizePlaintext = map toLower . filter isAlphaNum

plaintextSegments :: String -> [String]
plaintextSegments s = chunk (squareSize text) text
  where text = normalizePlaintext s

cipherSegments :: String -> [String]
cipherSegments s = map (everyNth cols . flip drop s) [0 .. pred cols]
  where cols = squareSize s

ciphertext :: String -> String
ciphertext = concat . cipherSegments . normalizePlaintext

normalizeCiphertext :: String -> String
normalizeCiphertext = intercalate " " . chunk 5 . ciphertext
