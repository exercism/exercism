module Luhn (checkDigit, addends, checksum, isValid, create) where

revDigits :: Integral a => a -> [a]
revDigits n = rem10 : digits
  where (quot10, rem10) = n `quotRem` 10
        digits | quot10 == 0 = []
               | otherwise   = revDigits quot10

luhnDouble :: Integral a => a -> a
luhnDouble n | n < 5     = n * 2
             | otherwise = n * 2 - 9

luhnDigits :: Integral a => a -> [a]
luhnDigits = zipWith ($) (cycle [id, luhnDouble]) . revDigits

checkDigit :: Integral a => a -> a
checkDigit = head . revDigits

addends :: Integral a => a -> [a]
addends = reverse . luhnDigits

checksum :: Integral a => a -> a
checksum = (`rem` 10) . sum . luhnDigits

isValid :: Integral a => a -> Bool
isValid = (0 ==) . checksum

create :: Integral a => a -> a
create n | chk == 0  = n10
         | otherwise = n10 + (10 - chk)
  where n10 = n * 10
        chk = checksum n10 `rem` 10
