import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import ETL (transform)
import qualified Data.Map as M

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList transformTests ]

transformTests :: [Test]
transformTests =
  [ testCase "transform one value" $
    M.fromList [('A', 1)] @=? transform (M.fromList [(1, ['A'])])
  , testCase "transform multiple keys from one value" $
    M.fromList [('A', 1), ('E', 1)] @=? transform (M.fromList [(1, ['A', 'E'])])
  , testCase "transform multiple keys from multiple values" $
    M.fromList [('A', 1), ('B', 4)] @=?
    transform (M.fromList [(1, ['A']), (4, ['B'])])
  , testCase "full dataset" $
    M.fromList fullOut @=? transform (M.fromList fullIn)
  ]

fullOut :: [(Char, Int)]
fullOut =
  [ ('A', 1), ('B', 3), ('C', 3), ('D', 2), ('E', 1)
  , ('F', 4), ('G', 2), ('H', 4), ('I', 1), ('J', 8)
  , ('K', 5), ('L', 1), ('M', 3), ('N', 1), ('O', 1)
  , ('P', 3), ('Q', 10), ('R', 1), ('S', 1), ('T', 1)
  , ('U', 1), ('V', 4), ('W', 4), ('X', 8), ('Y', 4)
  , ('Z', 10) ]

fullIn :: [(Int, [Char])]
fullIn =
  [ (1, "AEIOULNRST")
  , (2, "DG")
  , (3, "BCMP")
  , (4, "FHVWY")
  , (5, "K")
  , (8, "JX")
  , (10, "QZ")
  ]
