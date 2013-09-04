module Meetup (Weekday(..), Schedule(..), meetupDay) where
import Data.Time.Calendar (Day, addDays, fromGregorian, addGregorianMonthsClip)
import Data.Time.Calendar.WeekDate (toWeekDate)

data Weekday = Monday
             | Tuesday
             | Wednesday
             | Thursday
             | Friday
             | Saturday
             | Sunday
             deriving (Enum)

data Schedule = First
              | Second
              | Third
              | Fourth
              | Last
              | Teenth
              deriving (Enum)

type Year = Integer
type Month = Int

addWeeks :: Int -> Day -> Day
addWeeks = addDays . (7 *) . fromIntegral

weekdayNum :: Weekday -> Int
weekdayNum = succ . fromEnum

toWeekday :: Weekday -> Day -> Day
toWeekday w d = fromIntegral offset `addDays` d
  where offset | wnum >= wd = wnum - wd
               | otherwise  = 7 + wnum - wd
        wnum = weekdayNum w
        (_, _, wd) = toWeekDate d

meetupDay :: Schedule -> Weekday -> Year -> Month -> Day
meetupDay schedule weekday year month =
  case schedule of
    Last   -> (-1) `addWeeks` calcDay nextMonthStart
    Teenth -> calcDay $ 12 `addDays` monthStart
    enum   -> fromEnum enum `addWeeks` firstDay
  where
    calcDay = toWeekday weekday
    monthStart = fromGregorian year month 1
    nextMonthStart = addGregorianMonthsClip 1 monthStart
    firstDay = calcDay monthStart
