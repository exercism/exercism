(ns anagram.test (:require [clojure.test :refer :all]))
(load-file "anagram.clj")

(deftest no-matches
  (is (= [] (anagram/anagrams-for "diaper" ["hello" "world" "zombies" "pants"]))))

(deftest detect-simple-anagram
  (is (= ["tan"] (anagram/anagrams-for "ant" ["tan" "stand" "at"]))))

(deftest does-not-confuse-different-duplicates
  (is (= [] (anagram/anagrams-for "galea" ["eagle"]))))

(deftest eliminate-anagram-subsets
  (is (= [] (anagram/anagrams-for "good" ["dog" "goody"]))))

(deftest detect-anagram
  (is (= ["inlets"] (anagram/anagrams-for "listen" ["enlists" "google" "inlets" "banana"]))))

(deftest multiple-anagrams
  (is (= ["gallery" "regally" "largely"]
         (anagram/anagrams-for "allergy" ["gallery" "ballerina" "regally" "clergy" "largely" "leading"]))))

(deftest case-insensitive-anagrams
  (is (= ["Carthorse"]
         (anagram/anagrams-for "Orchestra" ["cashregister" "Carthorse" "radishes"]))))

(deftest word-is-not-own-anagram
  (is (= [] (anagram/anagrams-for "banana" ["banana"]))))

(run-tests)
