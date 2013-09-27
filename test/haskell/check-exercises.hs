#!/usr/bin/env runhaskell
-- Run this script from the root of the exercism checkout!
module Main where
import System.Exit (ExitCode(..), exitFailure)
import System.Posix.Temp (mkdtemp)
import System.Directory ( removeDirectoryRecursive, getTemporaryDirectory
                        , getCurrentDirectory, setCurrentDirectory, copyFile
                        , getDirectoryContents, removeFile )
import Control.Exception (bracket, finally)
import System.FilePath ((</>))
import System.Cmd (rawSystem)
import Data.List (isPrefixOf, intercalate)
import Data.Maybe (catMaybes)
import Control.Applicative

withTemporaryDirectory_ :: FilePath -> IO a -> IO a
withTemporaryDirectory_ fp f =
     do sysTmpDir <- getTemporaryDirectory
        curDir <- getCurrentDirectory
        bracket (mkdtemp (sysTmpDir </> fp))
                (\path -> setCurrentDirectory curDir >>
                          removeDirectoryRecursive path)
                (\path -> setCurrentDirectory path >> f)

assignmentsDir :: FilePath
assignmentsDir = "assignments/haskell"

parseModule :: [String] -> String
parseModule = (!!1) . words . head . filter (isPrefixOf "module ")

testAssignment :: FilePath -> FilePath -> IO (Maybe String)
testAssignment dir fn = do
  let d = dir </> fn
      example = d </> "example.hs"
      testFile = d </> (fn ++ "_test.hs")
  putStrLn $ "-- " ++ fn
  modFile <- (++ ".hs") . parseModule . lines <$> readFile example
  copyFile example modFile
  exitCode <- finally (rawSystem "runhaskell" [testFile]) (removeFile modFile)
  return $ case exitCode of
    ExitSuccess -> Nothing
    _           -> Just fn

getAssignments :: FilePath -> IO [FilePath]
getAssignments = (filter (not . isPrefixOf ".") <$>) . getDirectoryContents

main :: IO ()
main = do
  dir <- (</> assignmentsDir) <$> getCurrentDirectory
  withTemporaryDirectory_ "exercism-haskell" $ do
    failures <- catMaybes <$> (getAssignments dir >>= mapM (testAssignment dir))
    case failures of
      [] -> putStrLn "SUCCESS!"
      xs -> putStrLn ("Failures: " ++ intercalate ", " xs) >> exitFailure
