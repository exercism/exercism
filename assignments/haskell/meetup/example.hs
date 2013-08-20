module Meetup (Weekday(..), Schedule(..), meetupDay) where
import Data.Time.Calendar (Day, addDays, fromGregorian, addGregorianMonthsClip)
import Data.Time.Calendar.WeekDate (toWeekDate)

data Weekday = Sunday
             | Monday
             | Tuesday
             | Wednesday
             | Thursday
             | Friday
             | Saturday
data Schedule = First
              | Second
              | Third
              | Fourth
              | Last
              | Teenth
type Year = Integer
type Month = Int

addWeeks :: Integer -> Day -> Day
addWeeks = addDays . (7 *)

weekdayNum :: Weekday -> Int
weekdayNum w = case w of
  Monday    -> 1
  Tuesday   -> 2
  Wednesday -> 3
  Thursday  -> 4
  Friday    -> 5
  Saturday  -> 6
  Sunday    -> 7

toWeekday :: Weekday -> Day -> Day
toWeekday w d = addDays (fromIntegral offset) d
  where offset | wnum >= wd = wnum - wd
               | otherwise  = 7 + wnum - wd
        wnum = weekdayNum w
        (_, _, wd) = toWeekDate d

meetupDay :: Schedule -> Weekday -> Year -> Month -> Day
meetupDay schedule weekday year month =
  case schedule of
    First  -> firstDay
    Second -> 1 `addWeeks` firstDay
    Third  -> 2 `addWeeks` firstDay
    Fourth -> 3 `addWeeks` firstDay
    Last   -> (-1) `addWeeks` toWeekday weekday nextMonthStart
    Teenth -> toWeekday weekday (addDays 12 monthStart)
  where
    monthStart = fromGregorian year month 1
    nextMonthStart = addGregorianMonthsClip 1 monthStart
    firstDay = toWeekday weekday monthStart