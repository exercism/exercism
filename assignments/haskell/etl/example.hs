module ETL (transform) where
import qualified Data.Map as M

type PointValue = Int
type LowerTile = Char
type UpperTile = Char

transform :: M.Map PointValue [UpperTile] -> M.Map LowerTile PointValue
transform = M.fromList . concatMap go . M.toList
  where go (v, tiles) = zip (tiles) (repeat v)
