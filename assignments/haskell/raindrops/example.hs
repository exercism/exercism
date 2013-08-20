module Raindrops (convert) where
import Data.Monoid (mappend)

convert :: Int -> String
convert n = maybe (show n) id maybeSound
  where
    maybeSound = sound "Pling" 3 `mappend`
                 sound "Plang" 5 `mappend`
                 sound "Plong" 7
    sound noise factor | n `rem` factor == 0 = Just noise
                       | otherwise           = Nothing
