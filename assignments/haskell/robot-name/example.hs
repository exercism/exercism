module Robot (Robot, mkRobot, robotName, resetName) where

import Control.Concurrent (MVar, readMVar, swapMVar, newMVar)
import Control.Monad (void)
import System.Random (randomRIO)

data Robot = Robot { robotNameVar :: MVar String }

mkRobot :: IO Robot
mkRobot = generateName >>= newMVar >>= return . Robot

resetName :: Robot -> IO ()
resetName r = void (generateName >>= swapMVar (robotNameVar r))

robotName :: Robot -> IO String
robotName = readMVar . robotNameVar

generateName :: IO String
generateName = mapM randomRIO pattern
  where pattern = [ letter, letter, digit, digit, digit ]
        letter = ('A', 'Z')
        digit = ('0', '9')
