import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import qualified LinkedList as L

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
  [ TestList listTests ]

listTests :: [Test]
listTests =
  [ testCase "constructor" $ do
    True @=? L.isNil L.nil
    1 @=? L.datum one
    True @=? L.isNil (L.next one)
    2 @=? L.datum two
    1 @=? L.datum (L.next two)
    True @=? L.isNil (L.next $ L.next two)
  , testCase "toList" $ do
    ([] :: [Int]) @=? L.toList L.nil
    [1] @=? L.toList one
    [2, 1] @=? L.toList two
  , testCase "fromList" $ do
    True @=? L.isNil (L.fromList [])
    let one_a = L.fromList [1 :: Int]
    1 @=? L.datum one_a
    True @=? L.isNil (L.next one_a)
    let two_a = L.fromList [2, 1 :: Int]
    2 @=? L.datum two_a
    1 @=? L.datum (L.next two_a)
    True @=? L.isNil (L.next $ L.next two_a)
  , testCase "reverseList" $ do
    True @=? L.isNil (L.reverseLinkedList L.nil)
    let one_r = L.reverseLinkedList one
    1 @=? L.datum one_r
    True @=? L.isNil (L.next one_r)
    let two_r = L.reverseLinkedList two
    1 @=? L.datum two_r
    2 @=? L.datum (L.next two_r)
    True @=? L.isNil (L.next $ L.next two_r)
  , testCase "roundtrip" $ do
    ([] :: [Int]) @=? (L.toList . L.fromList) []
    ([1] :: [Int]) @=? (L.toList . L.fromList) [1]
    ([1, 2] :: [Int]) @=? (L.toList . L.fromList) [1, 2]
    ([1..10] :: [Int]) @=? (L.toList . L.fromList) [1..10]
  ]
  where
    one = L.new (1 :: Int) L.nil
    two = L.new (2 :: Int) one
