{-# LANGUAGE TemplateHaskell #-}
import Test.QuickCheck
import Test.QuickCheck.All (quickCheckAll)
import System.Exit (ExitCode(..), exitWith)
import Octal (showOct, readOct)
import qualified Numeric as N

{-
For the appropriate amount of challenge here, you should only
use functionality present in Prelude. Try not to use
Data.List, Data.Char, Data.Bits, or Numeric.

Try and use seq, $!, or BangPatterns appropriately to ensure
that the solution is efficient.

Handling invalid input is not necessary.
-}

exitProperly :: IO Bool -> IO ()
exitProperly m = do
  didSucceed <- m
  exitWith $ if didSucceed then ExitSuccess else ExitFailure 1

prop_showOct_integral :: (Integral a, Show a) => (Positive a) -> Bool
prop_showOct_integral (Positive n) = N.showOct n "" == showOct n

prop_showOct_int :: (Positive Int) -> Bool
prop_showOct_int = prop_showOct_integral


prop_readOct_integral :: (Integral a, Show a) => (Positive a) -> Bool
prop_readOct_integral (Positive n) = n == readOct (N.showOct n "")

prop_readOct_int :: (Positive Int) -> Bool
prop_readOct_int = prop_readOct_integral

main :: IO ()
main = exitProperly $quickCheckAll