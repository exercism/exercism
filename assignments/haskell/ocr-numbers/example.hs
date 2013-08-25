module OCR (convert) where
import Data.List.Split (chunksOf)
import Data.List (transpose, intercalate)

import qualified Data.Map as M

type CharVec = [String]

convert :: String -> String
convert = intercalate "," . map (map recognizeDigit) . grid
  where
    grid = map gridRow . chunksOf digitRows . lines
    gridRow = transpose . map (chunksOf digitCols)
    recognizeDigit = flip (M.findWithDefault garble) digitMap
    digitCols = 3
    digitRows = 4
    garble = '?'

digitMap :: M.Map CharVec Char
digitMap = M.fromList $ flip zip ['0'..'9'] $
  [ [ " _ "
    , "| |"
    , "|_|"
    , "   " ]
  , [ "   "
    , "  |"
    , "  |"
    , "   " ]
  , [ " _ "
    , " _|"
    , "|_ "
    , "   " ]
  , [ " _ "
    , " _|"
    , " _|"
    , "   " ]
  , [ "   "
    , "|_|"
    , "  |"
    , "   " ]
  , [ " _ "
    , "|_ "
    , " _|"
    , "   " ]
  , [ " _ "
    , "|_ "
    , "|_|"
    , "   " ]
  , [ " _ "
    , "  |"
    , "  |"
    , "   " ]
  , [ " _ "
    , "|_|"
    , "|_|"
    , "   " ]
  , [ " _ "
    , "|_|"
    , " _|"
    , "   " ] ]