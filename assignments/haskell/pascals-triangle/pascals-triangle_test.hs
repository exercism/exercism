import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Triangle (row, triangle)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList triangleTests ]

triangleTests :: [Test]
triangleTests =
  [ testCase "1 row" $
    [[1]] @=? take 1 (triangle :: [[Int]])
  , testCase "2 rows" $
    [[1], [1, 1]] @=? take 2 (triangle :: [[Int]])
  , testCase "3 rows" $
    [[1], [1, 1], [1, 2, 1]] @=? take 3 (triangle :: [[Int]])
  , testCase "4 rows" $
    [[1], [1, 1], [1, 2, 1], [1, 3, 3, 1]] @=? take 4 (triangle :: [[Int]])
  , testCase "5th row" $
    [1, 4, 6, 4, 1] @=? (row 5 :: [Int])
  , testCase "20th row" $
    [(1 :: Int), 19, 171, 969, 3876, 11628, 27132, 50388, 75582, 92378
    , 92378, 75582, 50388, 27132, 11628, 3876, 969, 171, 19, 1] @=? row 20
  , testCase "201st row maximum" $
    (product [101..200] `div` product [1..100] :: Integer) @=? row 201 !! 100
  ]
