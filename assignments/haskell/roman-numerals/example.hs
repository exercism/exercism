module Roman (numerals) where

numerals :: Int -> String
numerals = go numeralMap
  where
    go pairs@((value, digits):pairs') n
      | n >= value = digits ++ go pairs (n - value)
      | otherwise  = go pairs' n
    go [] _ = ""
    numeralMap = [ (1000, "M"), (900, "CM")
                 , (500, "D"), (400, "CD")
                 , (100, "C"), (90, "XC")
                 , (50, "L"), (40, "XL")
                 , (10, "X"), (9, "IX")
                 , (5, "V"), (4, "IV")
                 , (1, "I") ]
