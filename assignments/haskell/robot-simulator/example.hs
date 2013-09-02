module Robot (Bearing(..),
              Robot,
              mkRobot,
              coordinates,
              bearing,
              simulate,
              turnRight,
              turnLeft
              ) where
import Data.List (foldl')
import Control.Arrow (first, second)

data Movement = TurnLeft
              | TurnRight
              | Advance
              deriving (Show, Eq, Enum)

data Bearing = North
               | East
               | South
               | West
               deriving (Show, Eq, Enum, Bounded)

type Coordinates = (Int, Int)

data Robot = Robot { bearing :: Bearing
                   , coordinates :: Coordinates
                   } deriving (Show, Eq)
mkRobot :: Bearing -> Coordinates -> Robot
mkRobot = Robot

advance :: Bearing -> Coordinates -> Coordinates
advance dir = case dir of
  North -> second succ
  East  -> first succ
  South -> second pred
  West  -> first pred

turnLeft, turnRight :: Bearing -> Bearing
turnLeft d | d == minBound = maxBound
           | otherwise     = pred d

turnRight d | d == maxBound = minBound
            | otherwise     = succ d

instructions :: String -> [Movement]
instructions = map fromChar
  where fromChar c = case c of
          'L' -> TurnLeft
          'R' -> TurnRight
          'A' -> Advance
          _   -> error ("Unknown movement " ++ show c)

step :: Movement -> Robot -> Robot
step Advance   r = r { coordinates = advance (bearing r) (coordinates r) }
step TurnLeft  r = r { bearing = turnLeft (bearing r) }
step TurnRight r = r { bearing = turnRight (bearing r) }

simulate :: Robot -> String -> Robot
simulate r = foldl' (flip step) r . instructions
