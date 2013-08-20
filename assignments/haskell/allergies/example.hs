module Allergies (Allergen(..), isAllergicTo, allergies) where
import Data.Bits (testBit)
data Allergen = Eggs
              | Peanuts
              | Shellfish
              | Strawberries
              | Tomatoes
              | Chocolate
              | Pollen
              | Cats
              deriving (Show, Eq, Enum)

isAllergicTo :: Allergen -> Int -> Bool
isAllergicTo allergen code = testBit code (fromEnum allergen)

allergies :: Int -> [Allergen]
allergies code = filter (flip isAllergicTo code) [Eggs ..]
