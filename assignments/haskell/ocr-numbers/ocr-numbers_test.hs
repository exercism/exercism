import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import OCR (convert)

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
       [ TestList ocrTests ]

ocrTests :: [Test]
ocrTests =
  [ testCase "recognize zero" $
    "0" @=? convert (unlines
                     [ " _ "
                     , "| |"
                     , "|_|"
                     , "   " ])
  , testCase "recognizes one" $
    "1" @=? convert (unlines
                     [ "   "
                     , "  |"
                     , "  |"
                     , "   "])
  , testCase "recognizes two" $
    "2" @=? convert (unlines
                     [ " _ "
                     , " _|"
                     , "|_ "
                     , "   "])
  , testCase "recognizes three" $
    "3" @=? convert (unlines
                     [ " _ "
                     , " _|"
                     , " _|"
                     , "   " ])
  , testCase "recognises four" $
    "4" @=? convert (unlines
                     [ "   "
                     , "|_|"
                     , "  |"
                     , "   " ])
  , testCase "recognizes five" $
    "5" @=? convert (unlines
                     [ " _ "
                     , "|_ "
                     , " _|"
                     , "   " ])
  , testCase "recognizes six" $
    "6" @=? convert (unlines
                     [ " _ "
                     , "|_ "
                     , "|_|"
                     , "   "])
  , testCase "recognizes seven" $
    "7" @=? convert (unlines
                     [ " _ "
                     , "  |"
                     , "  |"
                     , "   " ])
  , testCase "recognizes eight" $
    "8" @=? convert (unlines
                     [ " _ "
                     , "|_|"
                     , "|_|"
                     , "   " ])
  , testCase "recognizes nine" $
    "9" @=? convert (unlines
                 [ " _ "
                 , "|_|"
                 , " _|"
                 , "   "])
  , testCase "recognizes garble" $
    "?" @=? convert (unlines
                     [ "   "
                     , "| |"
                     , "| |"
                     , "   " ])
  , testCase "recognizes ten" $
    "10" @=? convert (unlines
                      [ "    _ "
                      , "  || |"
                      , "  ||_|"
                      , "      " ])
  , testCase "recognizes 110101100" $
    "110101100" @=? convert (unlines
                             [ "       _     _        _  _ "
                             , "  |  || |  || |  |  || || |"
                             , "  |  ||_|  ||_|  |  ||_||_|"
                             , "                           " ])
  , testCase "identify with garble" $
    "11?10?1?0" @=? convert (unlines
                             [ "       _     _           _ "
                             , "  |  || |  || |     || || |"
                             , "  |  | _|  ||_|  |  ||_||_|"
                             , "                           " ])
  , testCase "identify 1234567890" $
    "1234567890" @=? convert (unlines
                              [ "    _  _     _  _  _  _  _  _ "
                              , "  | _| _||_||_ |_   ||_||_|| |"
                              , "  ||_  _|  | _||_|  ||_| _||_|"
                              , "                              " ])
  , testCase "identify 123,456,789" $
    "123,456,789" @=? convert (unlines
                               [ "    _  _ "
                               , "  | _| _|"
                               , "  ||_  _|"
                               , "         "
                               , "    _  _ "
                               , "|_||_ |_ "
                               , "  | _||_|"
                               , "         "
                               , " _  _  _ "
                               , "  ||_||_|"
                               , "  ||_| _|"
                               , "         " ])
  ]