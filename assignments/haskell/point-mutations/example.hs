module DNA (hammingDistance) where
hammingDistance :: String -> String -> Int
hammingDistance a b = sum $ map fromEnum $ zipWith (/=) a b
