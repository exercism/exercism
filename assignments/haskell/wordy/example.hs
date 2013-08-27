{-# LANGUAGE OverloadedStrings #-}
module WordProblem (answer) where
import Data.Text (pack)
import Data.List (foldl')
import Control.Applicative (pure, (<|>), (<$>), (<*>), (<*), (*>))
import Data.Attoparsec.Text

answerParser :: Parser Int
answerParser = do
  n <- "What is " .*> signed decimal
  ops <- many' (space *> operation)
  "?" .*> pure (foldl' (flip ($)) n ops)

answer :: String -> Maybe Int
answer = maybeResult . parse answerParser . pack

operation :: Parser (Int -> Int)
operation = (flip <$> operator) <* space <*> signed decimal

operator :: Parser (Int -> Int -> Int)
operator = "plus"          .*> pure (+) <|>
           "minus"         .*> pure (-) <|>
           "multiplied by" .*> pure (*) <|>
           "divided by"    .*> pure div