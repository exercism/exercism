import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Raindrops (convert)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList raindropsTests ]

raindropsTests :: [Test]
raindropsTests = map TestCase
  [ "1" @=? convert 1
  , "Pling" @=? convert 3
  , "Plang" @=? convert 5
  , "Plong" @=? convert 7
  , "Pling" @=? convert 6
  , "Pling" @=? convert 9
  , "Plang" @=? convert 10
  , "Plong" @=? convert 14
  , "PlingPlang" @=? convert 15
  , "PlingPlong" @=? convert 21
  , "Plang" @=? convert 25
  , "PlangPlong" @=? convert 35
  , "Plong" @=? convert 49
  , "52" @=? convert 52
  , "PlingPlangPlong" @=? convert 105
  , "12121" @=? convert 12121
  ]
