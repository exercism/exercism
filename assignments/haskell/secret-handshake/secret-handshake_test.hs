import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import SecretHandshake (handshake)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList handshakeTests ]

-- The trick to this one is defining the appropriate typeclass or typeclasses
-- to make handshake work with both Int and String. Granted, this is probably
-- not good API design for this exercise, but the technique is useful.
-- You may want to see http://www.haskell.org/haskellwiki/List_instance

handshakeTests :: [Test]
handshakeTests =
  [ testCase "1 to wink" $ do
    ["wink"] @=? handshake (1::Int)
    ["wink"] @=? handshake "1"
  , testCase "10 to double blink" $ do
    ["double blink"] @=? handshake (2::Int)
    ["double blink"] @=? handshake "10"
  , testCase "100 to close your eyes" $ do
    ["close your eyes"] @=? handshake (4::Int)
    ["close your eyes"] @=? handshake "100"
  , testCase "1000 to jump" $ do
    ["jump"] @=? handshake (8::Int)
    ["jump"] @=? handshake "1000"
  , testCase "11 to wink and double blink" $ do
    ["wink", "double blink"] @=? handshake (3::Int)
    ["wink", "double blink"] @=? handshake "11"
  , testCase "10011 to double blink and wink" $ do
    ["double blink", "wink"] @=? handshake (19::Int)
    ["double blink", "wink"] @=? handshake "10011"
  , testCase "11111 to jump, close your eyes, double blink, and wink" $ do
    ["jump", "close your eyes", "double blink", "wink"] @=? handshake (31::Int)
    ["jump", "close your eyes", "double blink", "wink"] @=? handshake "11111"
  , testCase "zero" $ do
    [] @=? handshake (0::Int)
    [] @=? handshake "0"
  , testCase "gibberish" $
    [] @=? handshake "piggies"
  , testCase "partial gibberish" $
    [] @=? handshake "1piggies"
  ]
