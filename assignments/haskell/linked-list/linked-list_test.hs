import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
-- Consider using Control.Concurrent.STM.TMVar or Control.Concurrent.MVar
-- to deal with the mutability
import Deque (mkDeque, push, pop, shift, unshift)

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = void $ runTestTT $ TestList
  [ TestList dequeTests ]

dequeTests :: [Test]
dequeTests =
  [ testCase "push pop" $ do
    deque <- mkDeque
    push deque 'a'
    push deque 'b'
    pop deque >>= (Just 'b' @=?)
    pop deque >>= (Just 'a' @=?)
  , testCase "push shift" $ do
    deque <- mkDeque
    push deque 'a'
    push deque 'b'
    shift deque >>= (Just 'a' @=?)
    shift deque >>= (Just 'b' @=?)
  , testCase "unshift shift" $ do
    deque <- mkDeque
    unshift deque 'a'
    unshift deque 'b'
    shift deque >>= (Just 'b' @=?)
    shift deque >>= (Just 'a' @=?)
  , testCase "unshift pop" $ do
    deque <- mkDeque
    unshift deque 'a'
    unshift deque 'b'
    pop deque >>= (Just 'a' @=?)
    pop deque >>= (Just 'b' @=?)
  , testCase "example" $ do
    deque <- mkDeque
    push deque 'a'
    push deque 'b'
    pop deque >>= (Just 'b' @=?)
    push deque 'c'
    shift deque >>= (Just 'a' @=?)
    unshift deque 'd'
    push deque 'e'
    shift deque >>= (Just 'd' @=?)
    pop deque >>= (Just 'e' @=?)
    pop deque >>= (Just 'c' @=?)
  ]
