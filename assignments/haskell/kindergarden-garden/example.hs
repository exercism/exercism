module Garden (garden, defaultGarden, lookupPlants, Plant(..)) where
import qualified Data.Map as M
import Data.List (sort)

data Plant = Grass
           | Clover
           | Radishes
           | Violets
           deriving (Enum, Eq, Show, Read)

type Student = String
type Garden = M.Map String [Plant]

defaultStudents :: [String]
defaultStudents =
  [ "Alice", "Bob", "Charlie", "David", "Eve", "Fred"
  , "Ginny", "Harriet", "Ileana", "Joseph", "Kincaid", "Larry"
  ]

fromChar :: Char -> Plant
fromChar c = case c of
  'G' -> Grass
  'C' -> Clover
  'R' -> Radishes
  'V' -> Violets
  _   -> error ("Unknown plant " ++ show c)

chunk :: Int -> [a] -> [[a]]
chunk _ [] = []
chunk n xs = ys : chunk n zs
  where (ys,zs) = splitAt n xs

defaultGarden :: String -> Garden
defaultGarden = garden defaultStudents

garden :: [Student] -> String -> Garden
garden students plantString = M.fromListWith (++) pairs
  where plantRows = map (map fromChar) (lines plantString)
        doRow = zip (sort students) . chunk 2
        pairs = concatMap doRow (reverse plantRows)

lookupPlants :: Student -> Garden -> [Plant]
lookupPlants = M.findWithDefault []
