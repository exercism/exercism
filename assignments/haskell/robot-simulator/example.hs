module Robot (Movement(..),
              Bearing(..),
              Robot,
              mkRobot,
              instructions,
              coordinates,
              bearing,
              simulate,
              turnRight,
              turnLeft
              ) where
import Data.List (foldl')

data Movement = TurnLeft
              | TurnRight
              | Advance
              deriving (Show, Eq, Enum)

data Bearing = North
               | East
               | South
               | West
               deriving (Show, Eq, Enum)

type Coordinates = (Int, Int)

data Robot = Robot { bearing :: Bearing
                   , coordinates :: Coordinates
                   } deriving (Show, Eq)
mkRobot :: Bearing -> Coordinates -> Robot
mkRobot = Robot

advance :: Bearing -> Coordinates -> Coordinates
advance dir (x, y) =
  case dir of
    North -> (x, y + 1)
    East  -> (x + 1, y)
    South -> (x, y - 1)
    West  -> (x - 1, y)

turnLeft :: Bearing -> Bearing
turnLeft North = West
turnLeft d = pred d

turnRight :: Bearing -> Bearing
turnRight West = North
turnRight d = succ d

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
