module Matrix ( Matrix, fromString, fromList
              , row, column, shape, rows, cols
              , transpose, reshape, flatten) where
import Control.Arrow ((&&&))
import qualified Data.Vector as V

data Matrix a = Matrix { matrixCells :: V.Vector a
                       , matrixRows  :: Int
                       , matrixCols  :: Int
                       } deriving (Show, Eq)

mkMatrix :: (Int, Int) -> V.Vector a -> Matrix a
mkMatrix (numRows, numCols) cells
  | numRows * numCols == V.length cells =
    Matrix { matrixCells = cells
           , matrixRows  = numRows
           , matrixCols  = numCols
           }
  | otherwise = error "invalid matrix shape"

rows :: Matrix a -> Int
rows = matrixRows

cols :: Matrix a -> Int
cols = matrixCols

shape :: Matrix a -> (Int, Int)
shape = matrixRows &&& matrixCols

row :: Int -> Matrix a -> V.Vector a
row n m = V.slice i numCols $ matrixCells m
  where numCols = matrixCols m
        i = n * numCols

column :: Int -> Matrix a -> V.Vector a
column n m = V.backpermute (matrixCells m) indexes
  where numCols = matrixCols m
        indexes = V.generate (matrixRows m) ((n +) . (numCols *))

transpose :: Matrix a -> Matrix a
transpose m = mkMatrix (numCols, numRows) permuted
  where numCols = matrixCols m
        numRows = matrixRows m
        permuted = V.backpermute (matrixCells m) indexes
        indexes = V.generate (numRows * numCols) indexAt
        indexAt n = let (c, r) = n `quotRem` numRows
                    in c + r * numCols

reshape :: (Int, Int) -> Matrix a -> Matrix a
reshape dim m = mkMatrix dim (matrixCells m)

flatten :: Matrix a -> V.Vector a
flatten = matrixCells

fromList :: [[a]] -> Matrix a
fromList xs | numRows == 0 || numCols == 0 = mkMatrix (0, 0) V.empty
            | otherwise                    = mkMatrix (numRows, numCols) v
  where numRows = length xs
        numCols = length (head xs)
        v = V.fromList $ concat xs

fromString :: Read a => String -> Matrix a
fromString = fromList . map readAll . lines
  where
    readAll s = case reads s of
      []          -> []
      (x, rest):_ -> x : readAll rest
