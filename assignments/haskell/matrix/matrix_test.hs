import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Matrix ( Matrix, row, column, rows, cols, shape, transpose
              , reshape, flatten, fromString, fromList)
import Control.Arrow ((&&&))
import qualified Data.Vector as V

-- Implementation of a row-major matrix for any type, using Data.Vector.

-- fromString should work for any type that implements the Read typeclass.
-- You can assume that "\n" is used to delimit rows without context
-- sensitivity, but treatment of whitespace in a row should be context
-- sensitive!

-- No validation of input is required. Let it fail if the matrix is not
-- rectangular, invalid chars are encountered, etc.

-- shape is (rows, cols)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList matrixTests ]

v :: [a] -> V.Vector a
v = V.fromList

msInt :: String -> Matrix Int
msInt = fromString

msInteger :: String -> Matrix Integer
msInteger = fromString

msChar :: String -> Matrix Char
msChar = fromString

msString :: String -> Matrix String
msString = fromString

matrixTests :: [Test]
matrixTests =
  [ testCase "extract first row" $ do
    v [1, 2] @=? row 0 (msInt "1 2\n10 20")
    v [9, 7] @=? row 0 (msInteger "9 7\n8 6")
  , testCase "extract second row" $ do
    v [19, 18, 17] @=? row 1 (msInt "9 8 7\n19 18 17")
    v [16, 25, 36] @=? row 1 (msInteger "1 4 9\n16 25 36")
  , testCase "extract first column" $ do
    v [1, 4, 7, 8] @=? column 0 (msInt "1 2 3\n4 5 6\n7 8 9\n 8 7 6")
    v [1903, 3, 4] @=? column 1 (msInteger "89 1903 3\n18 3 1\n9 4 800")
  , testCase "shape" $ do
    (0, 0) @=? shape (msInt "")
    (1, 1) @=? shape (msInt "1")
    (2, 1) @=? shape (msInt "1\n2")
    (1, 2) @=? shape (msInt "1 2")
    (2, 2) @=? shape (msInt "1 2\n3 4")
  , testCase "rows & cols" $
    (1, 2) @=? (rows &&& cols) (msInt "1 2")
  , testCase "eq" $
    msInt "1 2" @=? msInt "1 2"
  , testCase "fromList" $ do
    msInt "1 2" @=? fromList [[1, 2]]
    msInt "1\n2" @=? fromList [[1], [2]]
  , testCase "transpose" $ do
    msInt "1 2 3" @=? transpose (msInt "1\n2\n3")
    msInt "1 2 3\n4 5 6" @=? transpose (msInt "1 4\n2 5\n3 6")
  , testCase "reshape" $ do
    msInt "1 2\n3 4" @=? reshape (2, 2) (msInt "1 2 3 4")
  , testCase "flatten" $ do
    v [1, 2, 3, 4] @=? flatten (msInt "1 2\n3 4")
  , testCase "matrix of chars" $ do
    fromList ["foo", "bar"] @=? msChar "'f' 'o' 'o'\n'b' 'a' 'r'"
  , testCase "matrix of strings" $ do
    fromList [["this one"], ["may be tricky!"]] @=?
      msString "\"this one\"\n\"may be tricky!\""
  ]