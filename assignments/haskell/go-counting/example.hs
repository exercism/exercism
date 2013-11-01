module Counting (
    Color(..),
    territories,
    territoryFor
) where

import           Data.Array.IArray ((!), Array)
import qualified Data.Array.IArray as Array
import           Data.Maybe (catMaybes, mapMaybe)
import           Data.Set (Set)
import qualified Data.Set as Set

-- | A board is an efficient dense mapping of coordinates to stones (where
--   each point may either have a stone or not.
type Board = Array Coord (Maybe Color)

type Coord = (Int, Int) -- Coords are 1 based

data Color = Black | White
  deriving (Eq, Ord, Show, Enum, Bounded)

-- | Return the territories along with the side that has claimed them (if
--   any).
--
-- The input should consist of lines of equal length.
--
-- The character 'B' will mean black, the character 'W' will mean white and
-- every other character will mean an empty square.
territories :: [[Char]] -> [(Set Coord, Maybe Color)]
territories ls =
    let b   = buildBoard ls
        fps = freePoints b
    in worker [] b fps
  where
    worker ts _ []          = ts
    worker ts b fps@(fp:_)  =
        let s = groupContaining b fp
            o = groupOwner b s
        in worker ((s, o):ts) b (filter (`Set.notMember` s) fps)

-- | Return the territory and the side that has claimed it given
--   a coordinate that is in the territory. If the coordinate is not in any
--   territory returns Nothing.
--
-- See 'territories' for notes about the expected board format.
territoryFor :: [[Char]] -> Coord -> Maybe (Set Coord, Maybe Color)
territoryFor ls c =
    let b = buildBoard ls
        s = groupContaining b c
        o = groupOwner b s
    in if Set.null s
        then Nothing
        else Just (s, o)

-- | Transform the list of lines into a Board.
--
-- The character 'B' will mean black, the character 'W' will mean white and
-- every other character will mean an empty square.
--
-- The input must contain at least one line.
buildBoard :: [[Char]] -> Board
buildBoard ls =
    let xmax = length (head ls)
        ymax = length ls
        bounds = ((1,1), (xmax, ymax))
        assocs = [ ((x, y), toMColor c)
                 | (y, l) <- zip [1..] ls
                 , (x, c) <- zip [1..] l]
    in Array.array bounds assocs
  where
    toMColor 'B' = Just Black
    toMColor 'W' = Just White
    toMColor _   = Nothing

-- | Get the coordinates of all free points on the board.
freePoints :: Board -> [Coord]
freePoints = mapMaybe worker . Array.assocs
  where
    worker (_, Just _)  = Nothing
    worker (c, Nothing) = Just c

-- | True iff the coordinate is within the bounds of the board.
inBounds :: Board -> Coord -> Bool
inBounds b (cx, cy) =
    let ((xmin, ymin), (xmax, ymax)) = Array.bounds b
    in cx >= xmin && cx <= xmax && cy >= ymin && cy <= ymax

-- | True iff the point not occupied by a stone.
--
-- Does not check if the point is valid.
isFreePoint :: Board -> Coord -> Bool
isFreePoint b c = b ! c == Nothing

-- | Get the adjacent valid coordinates for a coordinate.
adjacentCoords :: Board -> Coord -> [Coord]
adjacentCoords b (cx, cy) =
    filter (inBounds b) [(cx+1, cy), (cx, cy+1), (cx-1, cy), (cx, cy-1)]

-- | Get a group of free points, starting with the given coordinate.
groupContaining :: Board -> Coord -> Set Coord
groupContaining b c | not (inBounds b c && isFreePoint b c) = Set.empty
                    | otherwise =
    -- The algorithm here is quite simple. In every iteration we add to
    -- a list all free points adjacent to points in the "last added" list.
    -- Then we add those points into the set and use the "last added" list
    -- in the next iteration.
    --
    -- Once no more free points are found in an iteration we are done.
    worker [c] (Set.singleton c)
  where
    worker [] s = s
    worker la s =
        let coords = (`Set.difference` s) . Set.fromList . catMaybes $ do
                        -- List monad
                        lc <- la
                        ac <- adjacentCoords b lc
                        return $ if isFreePoint b ac then Just ac else Nothing
        in worker (Set.toList coords) (Set.union s coords)

-- | Given a group of free points return who owns this territory (if
--   anyone).
--
-- The owner of a territory is the player whose stones are the only stones
-- adjacent to the territory (dead stones are assumed to have already been
-- removed).
groupOwner :: Board -> Set Coord -> Maybe Color
groupOwner b s =
    let stones = catMaybes [b ! ac | c <- Set.toList s, ac <- adjacentCoords b c]
    in case stones of
        []      -> Nothing
        (h:t)   -> if all (==h) t then Just h else Nothing
