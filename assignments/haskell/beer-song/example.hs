module Beer (verse, sing) where
import Data.Char (toUpper)

capitalize :: String -> String
capitalize (h : t) = toUpper h : t
capitalize [] = []

bottles :: Int -> String
bottles 1 = "bottle"
bottles _ = "bottles"

countBottles :: Int -> String
countBottles 0 = "no more"
countBottles n = show n

stanza :: Int -> String
stanza n | n >= 0    = countBottles n ++ " " ++ bottles n ++ " of beer"
         | otherwise = stanza 99

it :: Int -> String
it 1 = "it"
it _ = "one"

action :: Int -> String
action n | n > 0     = "Take " ++ it n ++ " down and pass it around"
         | otherwise = "Go to the store and buy some more"

verse :: Int -> String
verse n = unlines
  [ capitalize (stanza n) ++ " on the wall, " ++ stanza n ++ "."
  , action n ++ ", " ++ stanza (pred n) ++ " on the wall." ]

sing :: Int -> Int -> String
sing from to = unlines $ map verse [from, from - 1 .. to]
