import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import qualified School as S
import Data.List (foldl')

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList schoolTests ]

gradeWithStudents :: Int -> [String] -> S.School
gradeWithStudents gradeNum = schoolFromList . zip (repeat gradeNum)

schoolFromList :: [(Int, String)] -> S.School
schoolFromList = foldl' (flip $ uncurry S.add) S.empty

schoolTests :: [Test]
schoolTests =
  [ testCase "add student" $
    [(2, ["Aimee"])] @=? S.sorted (S.add 2 "Aimee" S.empty)
  , testCase "add more students in same class" $
    [(2, ["Blair", "James", "Paul"])] @=? S.sorted
    (gradeWithStudents 2 ["James", "Blair", "Paul"])
  , testCase "add students to different grades" $
    [(3, ["Chelsea"]), (7, ["Logan"])] @=? S.sorted
    (schoolFromList [(3, "Chelsea"), (7, "Logan")])
  , testCase "get students in a grade" $
    ["Bradley", "Franklin"] @=? S.grade 5
    (schoolFromList [(5, "Franklin"), (5, "Bradley"), (1, "Jeff")])
  , testCase "get students in a non-existent grade" $
    [] @=? S.grade 1 S.empty
  , testCase "sorted school" $
    [(3, ["Kyle"]),
     (4, ["Christopher", "Jennifer"]),
     (6, ["Kareem"])] @=? S.sorted
    (schoolFromList [(4, "Jennifer"), (6, "Kareem"),
                     (4, "Christopher"), (3, "Kyle")])
  ]