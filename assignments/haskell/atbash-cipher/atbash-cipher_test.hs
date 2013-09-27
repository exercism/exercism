import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Atbash (encode)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList atbashTests ]

atbashTests :: [Test]
atbashTests = map TestCase
  [ "ml" @=? encode "no"
  , "bvh" @=? encode "yes"
  , "lnt" @=? encode "OMG"
  , "lnt" @=? encode "O M G"
  , "nrmwy oldrm tob" @=? encode "mindblowingly"
  , "gvhgr mt123 gvhgr mt" @=? encode "Testing, 1 2 3, testing."
  , "gifgs rhurx grlm" @=? encode "Truth is fiction."
  , "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt" @=?
    encode "The quick brown fox jumps over the lazy dog."
  ]
