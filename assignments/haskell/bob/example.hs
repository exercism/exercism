module Bob (responseFor) where
import Data.Char (isSpace, isUpper, isAlpha)

data Prompt = Silence | Yell | Question | Other

classify :: String -> Prompt
classify s | all isSpace s = Silence
           | any isAlpha s && (all isUpper $ filter isAlpha s) = Yell
           | '?' == last s = Question
           | otherwise = Other

response :: Prompt -> String
response Silence = "Fine. Be that way."
response Yell = "Woah, chill out!"
response Question = "Sure."
response Other = "Whatever."

responseFor :: String -> String
responseFor = response . classify