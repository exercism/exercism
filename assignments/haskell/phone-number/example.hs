module Phone (number, areaCode, prettyPrint) where
import Data.Char (isDigit)

number :: String -> String
number input
  | len == 10 = digits
  | len == 11 && head digits == '1' = tail digits
  | otherwise = take 10 (repeat '0')
  where digits = filter isDigit input
        len = length digits

parts :: String -> (String, String, String)
parts input = (ac, exchange, subscriber)
  where
    (ac, exchangeSubscriber) = splitAt 3 (number input)
    (exchange, subscriber) = splitAt 3 exchangeSubscriber

areaCode :: String -> String
areaCode input = ac
  where (ac, _, _) = parts input

prettyPrint :: String -> String
prettyPrint input = "(" ++ ac ++ ") " ++ exchange ++ "-" ++ subscriber
  where (ac, exchange, subscriber) = parts input
