import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Luhn (checkDigit, addends, checksum, isValid, create)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList luhnTests ]

int :: Integer -> Integer
int = id

ints :: [Integer] -> [Integer]
ints = id

luhnTests :: [Test]
luhnTests =
  [ testCase "checkDigit" $ do
    int 7 @=? checkDigit 34567
    int 0 @=? checkDigit 91370
  , testCase "addends" $ do
    ints [1, 4, 1, 4, 1] @=? addends 12121
    ints [7, 6, 6, 1] @=? addends 8631
  , testCase "checksum" $ do
    -- NOTE: this differs from the ruby and js, the checksum really should
    --       be mod 10 like we are testing here.
    int 2 @=? checksum 4913
    int 1 @=? checksum 201773
  , testCase "isValid" $ do
    False @=? isValid (int 738)
    True @=? isValid (int 8739567)
  , testCase "create" $ do
    int 1230 @=? create 123
    int 8739567 @=? create 873956
    int 8372637564 @=? create 837263756
  ]