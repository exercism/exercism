import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Garden (garden, defaultGarden, lookupPlants, Plant(..))

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
  [ TestList gardenTests ]

gardenTests :: [Test]
gardenTests =
  [ testCase "alice tests" $ do
    let alice = lookupPlants "Alice" . defaultGarden
    [Radishes, Clover, Grass, Grass] @=? alice "RC\nGG"
    [Violets, Clover, Radishes, Clover] @=? alice "VC\nRC"
  , testCase "small garden" $
    [Clover, Grass, Radishes, Clover] @=?
    lookupPlants "Bob" (defaultGarden "VVCG\nVVRC")
  , testCase "medium garden" $ do
    let g = defaultGarden "VVCCGG\nVVCCGG"
    [Clover, Clover, Clover, Clover] @=? lookupPlants "Bob" g
    [Grass, Grass, Grass, Grass] @=? lookupPlants "Charlie" g
  , testCase "full garden" $ do
    let g = defaultGarden "VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV"
        l = flip lookupPlants g
    [Violets, Radishes, Violets, Radishes] @=? l "Alice"
    [Clover, Grass, Clover, Clover] @=? l "Bob"
    [Violets, Violets, Clover, Grass] @=? l "Charlie"
    [Radishes, Violets, Clover, Radishes] @=? l "David"
    [Clover, Grass, Radishes, Grass] @=? l "Eve"
    [Grass, Clover, Violets, Clover] @=? l "Fred"
    [Clover, Grass, Grass, Clover] @=? l "Ginny"
    [Violets, Radishes, Radishes, Violets] @=? l "Harriet"
    [Grass, Clover, Violets, Clover] @=? l "Ileana"
    [Violets, Clover, Violets, Grass] @=? l "Joseph"
    [Grass, Clover, Clover, Grass] @=? l "Kincaid"
    [Grass, Violets, Clover, Violets] @=? l "Larry"
  , testCase "surprise garden" $ do
    let g = garden [ "Samantha", "Patricia"
                   , "Xander", "Roger"
                   ] "VCRRGVRG\nRVGCCGCV"
        l = flip lookupPlants g
    [Violets, Clover, Radishes, Violets] @=? l "Patricia"
    [Radishes, Radishes, Grass, Clover] @=? l "Roger"
    [Grass, Violets, Clover, Grass] @=? l "Samantha"
    [Radishes, Grass, Clover, Violets] @=? l "Xander"
  ]
