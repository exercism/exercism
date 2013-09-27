module PigLatin (translate) where
import Data.Char (isLetter)
import Data.List (isSuffixOf)

consonantCluster :: String -> (String, String)
consonantCluster = qu . break (`elem` "aeiou")
  where qu (cs, ('u':rest)) | "q" `isSuffixOf` cs = (cs ++ "u", rest)
        qu pair = pair

translateWord :: String -> String
translateWord w0 = concat [before, w, cs, "ay", after]
  where
    (before, w1) = break isLetter w0
    (w2, after)  = span isLetter w1
    (cs, w)      = consonantCluster w2

translate :: String -> String
translate = unwords . map translateWord . words
