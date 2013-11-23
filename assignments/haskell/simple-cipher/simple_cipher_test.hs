import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Cipher (caesarEncode, caesarDecode, caesarEncodeRandom)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList caesarTests ]

caesarTests :: [Test]
caesarTests =
  [ testCase "no-op encode" $ do
    ['a'..'z'] @=? caesarEncode "a" ['a'..'z']
    ['a'..'z'] @=? caesarEncode (repeat 'a') ['a'..'z']
  , testCase "no-op decode" $ do
    ['a'..'z'] @=? caesarDecode "a" ['a'..'z']
    ['a'..'z'] @=? caesarDecode (repeat 'a') ['a'..'z']
  , testCase "reversible" $ do
    let k0 = "alkjsdhflkjahsuid"
    "asdf" @=? caesarDecode k0 (caesarEncode k0 "asdf")
    let k1 = ['z','y'..'a']
    "asdf" @=? caesarDecode k1 (caesarEncode k1 "asdf")
  , testCase "known cipher" $ do
    let k = ['a'..'j']
        encode = caesarEncode k
        decode = caesarDecode k
    k @=? encode "aaaaaaaaaa"
    "aaaaaaaaaa" @=? decode k
    ['a'..'z'] @=? decode (encode ['a'..'z'])
    'z':['a'..'i'] @=? encode "zzzzzzzzzz"
  , testCase "double shift" $ do
    let plaintext = "iamapandabear"
        ciphertext = "qayaeaagaciai"
    ciphertext @=? caesarEncode plaintext plaintext
  , testCase "shift cipher" $ do
    let encode = caesarEncode "d"
        decode = caesarDecode "d"
    "dddddddddd" @=? encode "aaaaaaaaaa"
    "aaaaaaaaaa" @=? decode "dddddddddd"
    ['d'..'m'] @=? encode ['a'..'j']
    ['a'..'j'] @=? decode (encode ['a'..'j'])
  , testCase "random tests" $ do
    let plaintext = take 1000 (cycle ['a'..'z'])
    p1 <- caesarEncodeRandom plaintext
    plaintext @=? uncurry caesarDecode p1
    p2 <- caesarEncodeRandom plaintext
    plaintext @=? uncurry caesarDecode p2
    -- There's a small chance this could fail, since it's random.
    False @=? (p1 == p2)
  ]
