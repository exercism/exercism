import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import Robot (Bearing(..), Movement(..), Robot, mkRobot,
              instructions, coordinates, simulate,
              bearing, turnRight, turnLeft)

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = void $ runTestTT $ TestList
  [ TestList robotTests ]

robotTests :: [Test]
robotTests =
  [ testCase "turning edge cases" $ do
    North @=? turnRight West
    West @=? turnLeft North
  , testCase "robbie" $ do
    let robbie = mkRobot East (-2, 1)
    East @=? bearing robbie
    (-2, 1) @=? coordinates robbie
    let movedRobbie = simulate robbie "RLAALAL"
    West @=? bearing movedRobbie
    (0, 2) @=? coordinates movedRobbie
    mkRobot West (0, 2) @=? movedRobbie
  , testCase "clutz" $ do
    let clutz = mkRobot North (0, 0)
    mkRobot West (-4, 1) @=? simulate clutz "LAAARALA"
  , testCase "sphero" $ do
    let sphero = mkRobot East (2, -7)
    mkRobot South (-3, -8) @=? simulate sphero "RRAAAAALA"
  , testCase "roomba" $ do
    let roomba = mkRobot South (8, 4)
    mkRobot North (11, 5) @=? simulate roomba "LAAARRRALLLL"
  ]
