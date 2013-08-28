(ns anagram
  (:require [clojure.string :refer [split lower-case]]))

(defn- canonicalize
  [word]
  (-> word
      lower-case
      (split #"")
      sort))

(defn anagrams-for
  [word candidates]
  (let [canonical (canonicalize word)]
    (remove #(= word %) (filter #(= canonical (canonicalize %)) candidates))))
