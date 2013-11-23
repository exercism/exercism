import Test.HUnit (Assertion, (@=?), runTestTT, Test(..), Counts(..))
import System.Exit (ExitCode(..), exitWith)
import BankAccount ( BankAccount, openAccount, closeAccount
                   , getBalance, incrementBalance )
import Control.Concurrent
import Control.Monad (void, replicateM)

{-
The BankAccount module should support four calls:

openAccount
  Called at the start of each test. Returns a BankAccount.

closeAccount account
  Called at the end of each test.

getBalance account
  Get the balance of the bank account.

updateBalance account amount
  Increment the balance of the bank account by the given amount.
  The amount may be negative for a withdrawal.

The initial balance of the bank account should be 0.
-}

exitProperly :: IO Counts -> IO ()
exitProperly m = do
  counts <- m
  exitWith $ if failures counts /= 0 || errors counts /= 0 then ExitFailure 1 else ExitSuccess

testCase :: String -> Assertion -> Test
testCase label assertion = TestLabel label (TestCase assertion)

main :: IO ()
main = exitProperly $ runTestTT $ TestList
  [ withBank "initial balance is 0" $
    checkReturn (Just 0) . getBalance
  , withBank "incrementing and checking balance" $ \acct -> do
    checkReturn (Just 0) $ getBalance acct
    checkReturn (Just 10) $ incrementBalance acct 10
    checkReturn (Just 10) $ getBalance acct
  , withBank "incrementing balance from other processes then checking it\
             \from test process" $ \acct -> do
    replicateM 20 (incrementProc acct) >>= mapM_ (void . takeMVar)
    checkReturn (Just 20) (getBalance acct)
  ]

incrementProc :: BankAccount -> IO (MVar ())
incrementProc acct = do
  v <- newEmptyMVar
  void . forkIO $ do
    void (incrementBalance acct 1)
    putMVar v ()
  return v

checkReturn :: (Show a, Eq a) => a -> IO a -> IO ()
checkReturn expect test = do
  v <- test
  expect @=? v

withBank :: String -> (BankAccount -> Assertion) -> Test
withBank label f = testCase label $ do
  acct <- openAccount
  f acct
  closeAccount acct
