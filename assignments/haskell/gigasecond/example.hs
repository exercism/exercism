module Gigasecond (fromDay) where
import Data.Time.Calendar (Day, addDays)
fromDay :: Day -> Day
fromDay = addDays gigasecInDays
  where gigasecInDays = floor (1e9 / 86400 :: Float)
