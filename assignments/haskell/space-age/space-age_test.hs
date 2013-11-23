import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import SpaceAge (Planet(..), ageOn)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList ageOnTests ]

roundsTo :: Float -> Float -> Assertion
roundsTo a b = approx a @=? approx b
  where approx :: Float -> Int
        approx n = round (n * 100)

ageOnTests :: [Test]
ageOnTests =
  [ testCase "age in earth years" $
    31.69 `roundsTo` ageOn Earth 1000000000
  , testCase "age in mercury years" $ do
    let seconds = 2134835688
    67.65 `roundsTo` ageOn Earth seconds
    280.88 `roundsTo` ageOn Mercury seconds
  , testCase "age in venus years" $ do
    let seconds = 189839836
    6.02 `roundsTo` ageOn Earth seconds
    9.78 `roundsTo` ageOn Venus seconds
  , testCase "age on mars" $ do
    let seconds = 2329871239
    73.83 `roundsTo` ageOn Earth seconds
    39.25 `roundsTo` ageOn Mars seconds
  , testCase "age on jupiter" $ do
    let seconds = 901876382
    28.58 `roundsTo` ageOn Earth seconds
    2.41 `roundsTo` ageOn Jupiter seconds
  , testCase "age on saturn" $ do
    let seconds = 3000000000
    95.06 `roundsTo` ageOn Earth seconds
    3.23 `roundsTo` ageOn Saturn seconds
  , testCase "age on uranus" $ do
    let seconds = 3210123456
    101.72 `roundsTo` ageOn Earth seconds
    1.21 `roundsTo` ageOn Uranus seconds
  , testCase "age on neptune" $ do
    let seconds = 8210123456
    260.16 `roundsTo` ageOn Earth seconds
    1.58 `roundsTo` ageOn Neptune seconds
  ]
