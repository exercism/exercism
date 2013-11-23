import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Data.List (foldl', sort)
import qualified Data.Set as Set
import Counting (Color(..), territories, territoryFor)

-- Your code should define the following types:
--
--   data Color = Black | White
--     deriving (Eq, Ord, Show) -- More derivations are allowed
--
-- The signatures below assume the following type alias:
--
--   type Coord = (Int, Int)
--
-- Your code should define the following functions:
--
-- territories :: [[Char]] -> [(Set Coord, Maybe Color)]
--
--   Returns the coordinates (1 based, top left is (1,1)) of of the points
--   in each territory along with who "owns" the territory. A territory is
--   owned by one of the players if that player's stones are the only
--   stones adjacent to the territory.
--
-- territoryFor :: [[Char]] -> Coord -> Maybe (Set Coord, Maybe Color)
--
--   Returns the territory that contains the coordinate along with the
--   owner of the territory. If the coordinate does not point to an empty
--   location returns Nothing.

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList countingTests ]

type Coord = (Int, Int)

-- Helper for invoking 'territories' and getting an easy to compare result.
terrs :: [[Char]] -> [([Coord], Maybe Color)]
terrs = sort . map worker . territories
  where
    worker (s, o) = (Set.toAscList s, o)

-- Helper for invoking 'territoryFor' and getting an easy to compare
-- result.
terrFor :: [[Char]] -> Coord -> Maybe ([Coord], Maybe Color)
terrFor b c = case territoryFor b c of
                  Nothing     -> Nothing
                  Just (s, o) -> Just (Set.toAscList s, o)

-- | The score for black, white and none respectively.
data Score = Score {
    scoreBlack :: !Int,
    scoreWhite :: !Int,
    scoreNone  :: !Int
} deriving (Eq, Show)

-- Board to points: black, white, none.
score :: [[Char]] -> Score
score = foldl' worker (Score 0 0 0) . territories
  where
    worker sc (s, Just Black) = sc { scoreBlack = scoreBlack sc + Set.size s }
    worker sc (s, Just White) = sc { scoreWhite = scoreWhite sc + Set.size s }
    worker sc (s, Nothing)    = sc { scoreNone  = scoreNone sc  + Set.size s }

board5x5 :: [[Char]]
board5x5 =
    ["  B  ",
     " B B ",
     "B W B",
     " W W ",
     "  W  "]

board9x9 :: [[Char]]
board9x9 =
    ["  B   B  ",
     "B   B   B",
     "WBBBWBBBW",
     "W W W W W",
     "         ",
     " W W W W ",
     "B B   B B",
     " W BBB W ",
     "   B B   "]

countingTests :: [Test]
countingTests =
    [ testCase "minimal board, no territories" $
        [] @=? terrs ["B"],
      testCase "one territory, covering the whole board" $
        [([(1,1)], Nothing)] @=? terrs [" "],
      testCase "two territories, rectangular board" $
        [([(1,1), (1,2)], Just Black),
         ([(4,1), (4,2)], Just White)]
        @=? terrs [" BW ", " BW "],
      testCase "5x5 score" $
        Score 6 1 9 @=? score board5x5,
      testCase "5x5 territory for black" $
        Just ([(1,1), (1,2), (2,1)], Just Black)
        @=? terrFor board5x5 (1,2),
      testCase "5x5 territory for white" $
        Just ([(3,4)], Just White)
        @=? terrFor board5x5 (3,4),
      testCase "5x5 open territory" $
        Just ([(1,4), (1,5), (2,5)], Nothing)
        @=? terrFor board5x5 (2,5),
      testCase "5x5 non-territory (stone)" $
        Nothing @=? terrFor board5x5 (2,2),
      testCase "5x5 non-territory (too low coordinate)" $
        Nothing @=? terrFor board5x5 (0,2),
      testCase "5x5 non-territory (too high coordinate)" $
        Nothing @=? terrFor board5x5 (2,6),
      testCase "9x9 score" $
        Score 14 0 33 @=? score board9x9
    ]
