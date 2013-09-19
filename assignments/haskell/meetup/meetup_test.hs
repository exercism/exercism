import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import Meetup (Weekday(..), Schedule(..), meetupDay)
import Data.Time.Calendar (fromGregorian)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList meetupDayTests ]

-- NOTE: This would be a good opportunity to write some QuickCheck properties.
meetupDayTests :: [Test]
meetupDayTests =
  [ testCase "monteenth of may 2013" $
    fromGregorian 2013 5 13 @=? meetupDay Teenth Monday 2013 5
  , testCase "monteenth of august 2013" $
    fromGregorian 2013 8 19 @=? meetupDay Teenth Monday 2013 8
  , testCase "monteenth of september 2013" $
    fromGregorian 2013 9 16 @=? meetupDay Teenth Monday 2013 9
  , testCase "tuesteenth of march 2013" $
    fromGregorian 2013 3 19 @=? meetupDay Teenth Tuesday 2013 3
  , testCase "tuesteenth of april 2013" $
    fromGregorian 2013 4 16 @=? meetupDay Teenth Tuesday 2013 4
  , testCase "tuesteenth of august 2013" $
    fromGregorian 2013 8 13 @=? meetupDay Teenth Tuesday 2013 8
  , testCase "wednesteenth of january 2013" $
    fromGregorian 2013 1 16 @=? meetupDay Teenth Wednesday 2013 1
  , testCase "wednesteenth of februrary 2013" $
    fromGregorian 2013 2 13 @=? meetupDay Teenth Wednesday 2013 2
  , testCase "wednesteenth of june 2013" $
    fromGregorian 2013 6 19 @=? meetupDay Teenth Wednesday 2013 6
  , testCase "thursteenth of may 2013" $
    fromGregorian 2013 5 16 @=? meetupDay Teenth Thursday 2013 5
  , testCase "thursteenth of june 2013" $
    fromGregorian 2013 6 13 @=? meetupDay Teenth Thursday 2013 6
  , testCase "thursteenth of september 2013" $
    fromGregorian 2013 9 19 @=? meetupDay Teenth Thursday 2013 9
  , testCase "friteenth of april 2013" $
    fromGregorian 2013 4 19 @=? meetupDay Teenth Friday 2013 4
  , testCase "friteenth of august 2013" $
    fromGregorian 2013 8 16@=? meetupDay Teenth Friday 2013 8
  , testCase "friteenth of september 2013" $
    fromGregorian 2013 9 13@=? meetupDay Teenth Friday 2013 9
  , testCase "saturteenth of february 2013" $
    fromGregorian 2013 2 16 @=? meetupDay Teenth Saturday 2013 2
  , testCase "saturteenth of april 2013" $
    fromGregorian 2013 4 13 @=? meetupDay Teenth Saturday 2013 4
  , testCase "saturteenth of october 2013" $
    fromGregorian 2013 10 19 @=? meetupDay Teenth Saturday 2013 10
  , testCase "sunteenth of map 2013" $
    fromGregorian 2013 5 19 @=? meetupDay Teenth Sunday 2013 5
  , testCase "sunteenth of june 2013" $
    fromGregorian 2013 6 16 @=? meetupDay Teenth Sunday 2013 6
  , testCase "sunteenth of october 2013" $
    fromGregorian 2013 10 13 @=? meetupDay Teenth Sunday 2013 10
  , testCase "first Monday of march 2013" $
    fromGregorian 2013 3 4 @=? meetupDay First Monday 2013 3
  , testCase "first Monday of april 2013" $
    fromGregorian 2013 4 1 @=? meetupDay First Monday 2013 4
  , testCase "first Tuesday of may 2013" $
    fromGregorian 2013 5 7 @=? meetupDay First Tuesday 2013 5
  , testCase "first Tuesday of june 2013" $
    fromGregorian 2013 6 4 @=? meetupDay First Tuesday 2013 6
  , testCase "first Wednesday of july 2013" $
    fromGregorian 2013 7 3 @=? meetupDay First Wednesday 2013 7
  , testCase "first Wednesday of august 2013" $
    fromGregorian 2013 8 7 @=? meetupDay First Wednesday 2013 8
  , testCase "first Thursday of september 2013" $
    fromGregorian 2013 9 5 @=? meetupDay First Thursday 2013 9
  , testCase "first Thursday of october 2013" $
    fromGregorian 2013 10 3 @=? meetupDay First Thursday 2013 10
  , testCase "first Friday of november 2013" $
    fromGregorian 2013 11 1 @=? meetupDay First Friday 2013 11
  , testCase "first Friday of december 2013" $
    fromGregorian 2013 12 6 @=? meetupDay First Friday 2013 12
  , testCase "first Saturday of january 2013" $
    fromGregorian 2013 1 5 @=? meetupDay First Saturday 2013 1
  , testCase "first Saturday of february 2013" $
    fromGregorian 2013 2 2 @=? meetupDay First Saturday 2013 2
  , testCase "first Sunday of march 2013" $
    fromGregorian 2013 3 3 @=? meetupDay First Sunday 2013 3
  , testCase "first Sunday of april 2013" $
    fromGregorian 2013 4 7 @=? meetupDay First Sunday 2013 4
  , testCase "second Monday of march 2013" $
    fromGregorian 2013 3 11 @=? meetupDay Second Monday 2013 3
  , testCase "second Monday of april 2013" $
    fromGregorian 2013 4 8 @=? meetupDay Second Monday 2013 4
  , testCase "second Tuesday of may 2013" $
    fromGregorian 2013 5 14 @=? meetupDay Second Tuesday 2013 5
  , testCase "second Tuesday of june 2013" $
    fromGregorian 2013 6 11 @=? meetupDay Second Tuesday 2013 6
  , testCase "second Wednesday of july 2013" $
    fromGregorian 2013 7 10 @=? meetupDay Second Wednesday 2013 7
  , testCase "second Wednesday of august 2013" $
    fromGregorian 2013 8 14 @=? meetupDay Second Wednesday 2013 8
  , testCase "second Thursday of september 2013" $
    fromGregorian 2013 9 12 @=? meetupDay Second Thursday 2013 9
  , testCase "second Thursday of october 2013" $
    fromGregorian 2013 10 10 @=? meetupDay Second Thursday 2013 10
  , testCase "second Friday of november 2013" $
    fromGregorian 2013 11 8 @=? meetupDay Second Friday 2013 11
  , testCase "second Friday of december 2013" $
    fromGregorian 2013 12 13 @=? meetupDay Second Friday 2013 12
  , testCase "second Saturday of january 2013" $
    fromGregorian 2013 1 12 @=? meetupDay Second Saturday 2013 1
  , testCase "second Saturday of february 2013" $
    fromGregorian 2013 2 9 @=? meetupDay Second Saturday 2013 2
  , testCase "second Sunday of march 2013" $
    fromGregorian 2013 3 10 @=? meetupDay Second Sunday 2013 3
  , testCase "second Sunday of april 2013" $
    fromGregorian 2013 4 14 @=? meetupDay Second Sunday 2013 4
  , testCase "third Monday of march 2013" $
    fromGregorian 2013 3 18 @=? meetupDay Third Monday 2013 3
  , testCase "third Monday of april 2013" $
    fromGregorian 2013 4 15 @=? meetupDay Third Monday 2013 4
  , testCase "third Tuesday of may 2013" $
    fromGregorian 2013 5 21 @=? meetupDay Third Tuesday 2013 5
  , testCase "third Tuesday of june 2013" $
    fromGregorian 2013 6 18 @=? meetupDay Third Tuesday 2013 6
  , testCase "third Wednesday of july 2013" $
    fromGregorian 2013 7 17 @=? meetupDay Third Wednesday 2013 7
  , testCase "third Wednesday of august 2013" $
    fromGregorian 2013 8 21 @=? meetupDay Third Wednesday 2013 8
  , testCase "third Thursday of september 2013" $
    fromGregorian 2013 9 19 @=? meetupDay Third Thursday 2013 9
  , testCase "third Thursday of october 2013" $
    fromGregorian 2013 10 17 @=? meetupDay Third Thursday 2013 10
  , testCase "third Friday of november 2013" $
    fromGregorian 2013 11 15 @=? meetupDay Third Friday 2013 11
  , testCase "third Friday of december 2013" $
    fromGregorian 2013 12 20 @=? meetupDay Third Friday 2013 12
  , testCase "third Saturday of january 2013" $
    fromGregorian 2013 1 19 @=? meetupDay Third Saturday 2013 1
  , testCase "third Saturday of february 2013" $
    fromGregorian 2013 2 16 @=? meetupDay Third Saturday 2013 2
  , testCase "third Sunday of march 2013" $
    fromGregorian 2013 3 17 @=? meetupDay Third Sunday 2013 3
  , testCase "third Sunday of april 2013" $
    fromGregorian 2013 4 21 @=? meetupDay Third Sunday 2013 4
  , testCase "fourth Monday of march 2013" $
    fromGregorian 2013 3 25 @=? meetupDay Fourth Monday 2013 3
  , testCase "fourth Monday of april 2013" $
    fromGregorian 2013 4 22 @=? meetupDay Fourth Monday 2013 4
  , testCase "fourth Tuesday of may 2013" $
    fromGregorian 2013 5 28 @=? meetupDay Fourth Tuesday 2013 5
  , testCase "fourth Tuesday of june 2013" $
    fromGregorian 2013 6 25 @=? meetupDay Fourth Tuesday 2013 6
  , testCase "fourth Wednesday of july 2013" $
    fromGregorian 2013 7 24 @=? meetupDay Fourth Wednesday 2013 7
  , testCase "fourth Wednesday of august 2013" $
    fromGregorian 2013 8 28 @=? meetupDay Fourth Wednesday 2013 8
  , testCase "fourth Thursday of september 2013" $
    fromGregorian 2013 9 26 @=? meetupDay Fourth Thursday 2013 9
  , testCase "fourth Thursday of october 2013" $
    fromGregorian 2013 10 24 @=? meetupDay Fourth Thursday 2013 10
  , testCase "fourth Friday of november 2013" $
    fromGregorian 2013 11 22 @=? meetupDay Fourth Friday 2013 11
  , testCase "fourth Friday of december 2013" $
    fromGregorian 2013 12 27 @=? meetupDay Fourth Friday 2013 12
  , testCase "fourth Saturday of january 2013" $
    fromGregorian 2013 1 26 @=? meetupDay Fourth Saturday 2013 1
  , testCase "fourth Saturday of february 2013" $
    fromGregorian 2013 2 23 @=? meetupDay Fourth Saturday 2013 2
  , testCase "fourth Sunday of march 2013" $
    fromGregorian 2013 3 24 @=? meetupDay Fourth Sunday 2013 3
  , testCase "fourth Sunday of april 2013" $
    fromGregorian 2013 4 28 @=? meetupDay Fourth Sunday 2013 4
  , testCase "last Monday of march 2013" $
    fromGregorian 2013 3 25 @=? meetupDay Last Monday 2013 3
  , testCase "last Monday of april 2013" $
    fromGregorian 2013 4 29 @=? meetupDay Last Monday 2013 4
  , testCase "last Tuesday of may 2013" $
    fromGregorian 2013 5 28 @=? meetupDay Last Tuesday 2013 5
  , testCase "last Tuesday of june 2013" $
    fromGregorian 2013 6 25 @=? meetupDay Last Tuesday 2013 6
  , testCase "last Wednesday of july 2013" $
    fromGregorian 2013 7 31 @=? meetupDay Last Wednesday 2013 7
  , testCase "last Wednesday of august 2013" $
    fromGregorian 2013 8 28 @=? meetupDay Last Wednesday 2013 8
  , testCase "last Thursday of september 2013" $
    fromGregorian 2013 9 26 @=? meetupDay Last Thursday 2013 9
  , testCase "last Thursday of october 2013" $
    fromGregorian 2013 10 31 @=? meetupDay Last Thursday 2013 10
  , testCase "last Friday of november 2013" $
    fromGregorian 2013 11 29 @=? meetupDay Last Friday 2013 11
  , testCase "last Friday of december 2013" $
    fromGregorian 2013 12 27 @=? meetupDay Last Friday 2013 12
  , testCase "last Saturday of january 2013" $
    fromGregorian 2013 1 26 @=? meetupDay Last Saturday 2013 1
  , testCase "last Saturday of february 2013" $
    fromGregorian 2013 2 23 @=? meetupDay Last Saturday 2013 2
  , testCase "last Sunday of march 2013" $
    fromGregorian 2013 3 31 @=? meetupDay Last Sunday 2013 3
  , testCase "last Sunday of april 2013" $
    fromGregorian 2013 4 28 @=? meetupDay Last Sunday 2013 4
  ]
