import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import Triangle (TriangleType(..), triangleType)

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = void $ runTestTT $ TestList
       [ TestList triangleTests ]

tri :: Int -> Int -> Int -> TriangleType
tri = triangleType

triangleTests :: [Test]
triangleTests = map TestCase
  [ Equilateral @=? tri 2 2 2
  , Equilateral @=? tri 10 10 10
  , Isosceles @=? tri 3 4 4
  , Isosceles @=? tri 4 3 4
  , Scalene @=? tri 3 4 5
  , Illogical @=? tri 1 1 50
  , Illogical @=? tri 1 2 1
  ]
