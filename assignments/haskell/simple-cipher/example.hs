module Cipher (caesarEncode, caesarDecode, caesarEncodeRandom) where

import System.Random (newStdGen, randomRs)

caesarEncode, caesarDecode :: String -> String -> String
caesarEncode = caesar (+)
caesarDecode = caesar (-)

caesarEncodeRandom :: String -> IO (String, String)
caesarEncodeRandom xs = do
  g <- newStdGen
  let ks = take (length xs) (randomRs ('a', 'z') g)
  return (ks, caesarEncode ks xs)

caesar :: (Int -> Int -> Int) -> String -> String -> String
caesar op = zipWith rotate . cycle
  where
    rotate k x = if isAlpha k && isAlpha x
                then toAlpha (op (fromAlpha x) (fromAlpha k) `mod` 26)
                else x
    fromAlpha = subtract (fromEnum 'a') . fromEnum
    toAlpha = toEnum . (fromEnum 'a' +)
    isAlpha x = x >= 'a' && x <= 'z'
