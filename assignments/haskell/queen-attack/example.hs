module Queens (boardString, canAttack) where
import Control.Applicative ((<|>))
import Control.Monad (guard)
import Data.Maybe (fromJust)
type Position = (Int, Int)

boardString :: Maybe Position -> Maybe Position -> String
boardString w b = concat $ map rowString [0..7]
  where rowString row = concatMap (tileString row) [0..7]
        tileString row col = tileChar (row, col) : tileSep col
        tileSep 7 = "\n"
        tileSep _ = " "
        tileChar pos = fromJust $
                       (w >>= guard . (pos==) >> return 'W') <|>
                       (b >>= guard . (pos==) >> return 'B') <|>
                       return 'O'

canAttack :: Position -> Position -> Bool
canAttack (wr, wc) (br, bc) = sameRow || sameCol || diagonal
  where dr = wr - br
        dc = wc - bc
        sameRow  = dr == 0
        sameCol  = dc == 0
        diagonal = abs dr == abs dc