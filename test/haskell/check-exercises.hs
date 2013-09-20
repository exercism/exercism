#!/usr/bin/env runhaskell
-- Run this script from the root of the exercism checkout!
module Main where
import System.Exit (ExitCode(..), exitWith)
import System.Posix.Temp (mkdtemp)
import System.Directory ( removeDirectoryRecursive, getTemporaryDirectory
                        , getCurrentDirectory, setCurrentDirectory, copyFile
                        , getDirectoryContents, removeFile )
import Control.Exception (bracket, finally)
import System.FilePath ((</>))
import System.Cmd (rawSystem)
import Data.List (isPrefixOf)
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

testAssignment :: FilePath -> FilePath -> IO Bool
testAssignment dir fn = do
  let d = dir </> fn
      example = d </> "example.hs"
      testFile = d </> (fn ++ "_test.hs")
  putStrLn $ "-- " ++ fn
  modFile <- (++ ".hs") . parseModule . lines <$> readFile example
  copyFile example modFile
  (ExitSuccess ==) <$> finally
    (rawSystem "runhaskell" [testFile])
    (removeFile modFile)

getAssignments :: FilePath -> IO [FilePath]
getAssignments = (filter (not . isPrefixOf ".") <$>) . getDirectoryContents

main :: IO ()
main = do
  dir <- (</> assignmentsDir) <$> getCurrentDirectory
  withTemporaryDirectory_ "exercism-haskell" $ do
    didSucceed <- and <$> (getAssignments dir >>= mapM (testAssignment dir))
    putStrLn $ if didSucceed then "SUCCESS" else "FAILURES :("
    exitWith $ if didSucceed then ExitSuccess else ExitFailure 1
