import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Triangle (TriangleType(..), triangleType)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList triangleTests ]

tri :: Int -> Int -> Int -> TriangleType
tri = triangleType

triangleTests :: [Test]
triangleTests = map TestCase
  [ Equilateral @=? tri 2 2 2
  , Equilateral @=? tri 10 10 10
  , Isosceles @=? tri 3 4 4
  , Isosceles @=? tri 4 3 4
  , Scalene @=? tri 3 4 5
  , Illogical @=? tri 1 1 50
  , Illogical @=? tri 1 2 1
  ]
