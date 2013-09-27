import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Series (digits, slices, largestProduct)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
  [ TestList seriesTests ]

-- Allow implementations that work with Integral to compile without warning
ints :: [Int] -> [Int]
ints = id

int :: Int -> Int
int = id

seriesTests :: [Test]
seriesTests = map TestCase
  [ ints [0..9] @=? digits ['0'..'9']
  , ints [9,8..0] @=? digits ['9','8'..'0']
  , ints [8,7..4] @=? digits ['8','7'..'4']
  , ints [9, 3, 6, 9, 2, 3, 4, 6, 8] @=? digits "936923468"
  , map ints [[9, 8], [8, 2], [2, 7], [7, 3], [3, 4], [4, 6], [6, 3]] @=?
    slices 2 "98273463"
  , map ints [[9, 8, 2], [8, 2, 3], [2, 3, 4], [3, 4, 7]] @=?
    slices 3 "982347"
  , int 72 @=? largestProduct 2 "0123456789"
  , int 2 @=? largestProduct 2 "12"
  , int 9 @=? largestProduct 2 "19"
  , int 48 @=? largestProduct 2 "576802143"
  , int 504 @=? largestProduct 3 ['0'..'9']
  , int 270 @=? largestProduct 3 "1027839564"
  , int 15120 @=? largestProduct 5 ['0'..'9']
  , int 23520 @=?
    largestProduct 6 "73167176531330624919225119674426574742355349194934"
  , int 28350 @=?
    largestProduct 6 "52677741234314237566414902593461595376319419139427"
  , int 1 @=? largestProduct 0 ""
    -- unlike the Ruby implementation, no error is expected for too small input
  , int 1 @=? largestProduct 4 "123"
    -- edge case :)
  , int 0 @=? largestProduct 2 "00"
  ]
