import Test.HUnit (Assertion, (@=?), runTestTT, Test(..))
import Control.Monad (void)
import Scrabble (scoreLetter, scoreWord)

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = void $ runTestTT $ TestList
       [ TestList scrabbleTests ]

scrabbleTests :: [Test]
scrabbleTests = map TestCase
  [ 1 @=? scoreLetter 'a'
  , 1 @=? scoreLetter 'A'
  , 2 @=? scoreWord "at"
  , 6 @=? scoreWord "street"
  , 22 @=? scoreWord "quirky"
  , 20 @=? scoreWord "MULTIBILLIONAIRE"
  ]
