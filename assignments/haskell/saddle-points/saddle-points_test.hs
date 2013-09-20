import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Matrix (saddlePoints)
import Data.Array (listArray)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList matrixTests ]

matrixTests :: [Test]
matrixTests =
  [ testCase "Example from README" $ do
    let matrix = listArray ((0, 0), (2, 2))
                 [ 9, 8, 7
                 , 5, 3, 2
                 , 6, 6, 7 ]
    [(1, 0)] @=? saddlePoints matrix
  , testCase "no saddle point" $ do
    let matrix = listArray ((0, 0), (1, 1))
                 [ 2, 1
                 , 1, 2 ]
    [] @=? saddlePoints matrix
  , testCase "a saddle point" $ do
    let matrix = listArray ((0, 0), (1, 1))
                 [ 1, 2
                 , 3, 4 ]
    [(0, 1)] @=? saddlePoints matrix
  , testCase "another saddle point" $ do
    let matrix = listArray ((0, 0), (2, 4))
                 [ 18,  3, 39, 19,  91
                 , 38, 10,  8, 77, 320
                 ,  3,  4,  8,  6,   7 ]
    [(2, 2)] @=? saddlePoints matrix
  , testCase "multiple saddle points" $ do
    let matrix = listArray ((0, 0), (2, 2))
                 [ 4, 5, 4
                 , 3, 5, 5
                 , 1, 5, 4 ]
    [(0, 1), (1, 1), (2, 1)] @=? saddlePoints matrix
  ]
