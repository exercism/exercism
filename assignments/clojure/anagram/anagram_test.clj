(ns anagram.test (:use clojure.test))
(load-file "anagram.clj")

(deftest no-matches
  (is (= [] (anagram/anagrams-for "diaper" ["hello" "world" "zombies" "pants"]))))

(deftest detect-simple-anagram
  (is (= ["tan"] (anagram/anagrams-for "ant" ["tan" "stand" "at"]))))

(deftest does-not-confuse-different-duplicates
  (is (= [] (anagram/anagrams-for "galea" ["eagle"]))))

(deftest detect-anagram
  (is (= ["inlets"] (anagram/anagrams-for "listen" ["enlists" "google" "inlets" "banana"]))))

(deftest multiple-anagrams
  (is (= ["gallery" "regally" "largely"]
         (anagram/anagrams-for "allergy" ["gallery" "ballerina" "regally" "clergy" "largely" "leading"]))))

(run-tests)
