{-# LANGUAGE OverloadedStrings #-}

import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import qualified Data.Map as Map
import Data.Text (Text)
import qualified Data.Text as T
import Frequency (frequency)

-- Your code should contain a frequency :: Int -> [Text] -> Data.Map Char Int
-- function which accepts a number of workers to use in parallel and a list
-- of texts and returns the total frequency of each letter in the text.

-- Poem by Friedrich Schiller. The corresponding music is the European
-- Anthem.
ode_an_die_freude :: Text
ode_an_die_freude = T.concat
  ["Freude schöner Götterfunken"
  ,"Tochter aus Elysium,"
  ,"Wir betreten feuertrunken,"
  ,"Himmlische, dein Heiligtum!"
  ,"Deine Zauber binden wieder"
  ,"Was die Mode streng geteilt;"
  ,"Alle Menschen werden Brüder,"
  ,"Wo dein sanfter Flügel weilt."
  ]

-- Dutch national anthem
wilhelmus :: Text
wilhelmus = T.concat
  ["Wilhelmus van Nassouwe"
  ,"ben ik, van Duitsen bloed,"
  ,"den vaderland getrouwe"
  ,"blijf ik tot in den dood."
  ,"Een Prinse van Oranje"
  ,"ben ik, vrij, onverveerd,"
  ,"den Koning van Hispanje"
  ,"heb ik altijd geëerd."
  ]

-- American national anthem
star_spangled_banner :: Text
star_spangled_banner = T.concat
  ["O say can you see by the dawn's early light,"
  ,"What so proudly we hailed at the twilight's last gleaming,"
  ,"Whose broad stripes and bright stars through the perilous fight,"
  ,"O'er the ramparts we watched, were so gallantly streaming?"
  ,"And the rockets' red glare, the bombs bursting in air,"
  ,"Gave proof through the night that our flag was still there;"
  ,"O say does that star-spangled banner yet wave,"
  ,"O'er the land of the free and the home of the brave?"
  ]

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList freqTests ]

freqTests :: [Test]
freqTests = 
  [ testCase "no texts mean no letters" $ do
    Map.empty @=? frequency 1 []
  , testCase "one letter" $ do
    Map.singleton 'a' 1 @=? frequency 1 ["a"] 
  , testCase "case insensitivity" $ do
    Map.singleton 'a' 2 @=? frequency 1 ["aA"]
  , testCase "many empty texts still mean no letters" $ do
    Map.empty @=? frequency 1 (replicate 10000 "  ") 
  , testCase "many times the same text gives a predictable result" $ do
    Map.fromList [('a', 1000), ('b', 1000), ('c', 1000)]
        @=? frequency 1 (replicate 1000 "abc")
  , testCase "punctuation doesn't count" $ do
    let freqs = frequency 1 [ode_an_die_freude]
    Nothing @=? Map.lookup ',' freqs
  , testCase "numbers don't count" $ do
    let freqs = frequency 1 ["Testing, 1, 2, 3"]
    Nothing @=? Map.lookup '1' freqs
  , testCase "all three anthems, together, 1 worker" $ do
    let freqs = frequency 1 [ode_an_die_freude, wilhelmus, star_spangled_banner]
    Just 49 @=? Map.lookup 'a' freqs
    Just 56 @=? Map.lookup 't' freqs
    Just 2 @=? Map.lookup 'ü' freqs
  , testCase "all three anthems, together, 4 workers" $ do
    let freqs = frequency 4 [ode_an_die_freude, wilhelmus, star_spangled_banner]
    Just 49 @=? Map.lookup 'a' freqs
    Just 56 @=? Map.lookup 't' freqs
    Just 2 @=? Map.lookup 'ü' freqs
  ]
