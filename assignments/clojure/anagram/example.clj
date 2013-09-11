(ns anagram
  (:require [clojure.string :refer [split lower-case]]))

(defn- canonicalize
  [word]
  (-> word
      lower-case
      frequencies))

(defn anagrams-for
  [word candidates]
  (let [canonical (canonicalize word)]
    (vec (filter #(and (not= word %) (= canonical (canonicalize %))) candidates))))
