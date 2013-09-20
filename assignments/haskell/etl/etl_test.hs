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
    M.fromList [("a", 1)] @=? transform (M.fromList [(1, ["A"])])
  , testCase "transform multiple keys from one value" $
    M.fromList [("a", 1), ("e", 1)] @=? transform (M.fromList [(1, ["A", "E"])])
  , testCase "transform multiple keys from multiple values" $
    M.fromList [("a", 1), ("b", 4)] @=?
    transform (M.fromList [(1, ["A"]), (4, ["B"])])
  , testCase "full dataset" $
    M.fromList fullOut @=? transform (M.fromList fullIn)
  ]

fullOut :: [(String, Int)]
fullOut =
  [ ("a", 1), ("b", 3), ("c", 3), ("d", 2), ("e", 1)
  , ("f", 4), ("g", 2), ("h", 4), ("i", 1), ("j", 8)
  , ("k", 5), ("l", 1), ("m", 3), ("n", 1), ("o", 1)
  , ("p", 3), ("q", 10), ("r", 1), ("s", 1), ("t", 1)
  , ("u", 1), ("v", 4), ("w", 4), ("x", 8), ("y", 4)
  , ("z", 10) ]

fullIn :: [(Int, [String])]
fullIn =
  [ (1, map (:[]) "AEIOULNRST")
  , (2, ["D", "G"])
  , (3, map (:[]) "BCMP")
  , (4, map (:[]) "FHVWY")
  , (5, ["K"])
  , (8, ["J", "X"])
  , (10, ["Q", "Z"])
  ]