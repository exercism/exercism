module Say (inEnglish) where

import Data.Functor ((<$>))
import Data.Monoid ((<>))
import Data.Array (Array, listArray, (!))

smallNumbers :: Array Int String
smallNumbers = listArray (1, 19)
               [ "one", "two", "three", "four", "five", "six", "seven", "eight"
               , "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"
               , "fifteen", "sixteen", "seventeen", "eighteen", "nineteen" ]

tens :: Array Int String
tens = listArray (2, 9)
       [ "twenty", "thirty", "forty", "fifty"
       , "sixty", "seventy", "eighty", "ninety" ]

inEnglish :: Integral a => a -> Maybe String
inEnglish 0 = Just "zero"
inEnglish n0 | n0 > 0 && n0 < 1000000000000 = go n0 places
             | otherwise                    = Nothing
  where
    go 0 _ = Nothing
    go n ((place, name):ps)
      | n < place = go n ps
      | otherwise = go q hundreds <> Just (' ':name) <> ((' ':) <$> go r ps)
      where (q, r) = n `quotRem` place
    go n [] | n >= 1 && n < 20 = Just (smallNumbers ! fromIntegral n)
            | otherwise = Just (tens ! fromIntegral q) <> (('-':) <$> go r [])
      where (q, r) = n `quotRem` 10
    hundreds = [(100, "hundred")]
    places = (1000000000, "billion"):
             (1000000, "million"):
             (1000, "thousand"):
             hundreds