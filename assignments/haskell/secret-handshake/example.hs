module SecretHandshake (handshake) where

import Numeric (readInt)
import Data.Bits (testBit)

data Action = Wink
            | DoubleBlink
            | CloseYourEyes
            | Jump
            | Reverse
            deriving (Show, Eq, Enum, Bounded)

handshake :: Handshake a => a -> [String]
handshake = foldr f [] . toActions
  where f Reverse acc = reverse acc
        f action acc = toString action:acc
        toString action = case action of
          Wink          -> "wink"
          DoubleBlink   -> "double blink"
          CloseYourEyes -> "close your eyes"
          Jump          -> "jump"
          Reverse       -> undefined

class Handshake a where
  toActions :: a -> [Action]

instance Handshake Int where
  toActions n = [act | act <- Reverse:[Wink .. Jump], n `testBit` fromEnum act]

class BinParsable a where
  listToInt :: [a] -> Int

instance BinParsable Char where
    listToInt s = case readInt 2 isBin parseBin s of
      [(n, "")] -> n
      _         -> 0
      where isBin c = c == '0' || c == '1'
            parseBin = fromEnum . ('1'==)


instance BinParsable a => Handshake [a] where
  toActions = toActions . listToInt
