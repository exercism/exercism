(ns phrase
  (:require [clojure.string :refer [split lower-case]]))

(defn word-count
  "return a hash of unique words and how many times they appeared in the input string"
  [input]
  (->> (split input #"\W+")
       (map lower-case)
       (group-by identity)
       (reduce (fn [acc [word occurrences]]
                 (assoc acc word (count occurrences))) {})))

;; Another approach
(ns phrase
 (:require [clojure.string :refer [split lower-case]]))

(defn- sanitize-and-split [phrase]
  (-> (lower-case phrase)
      (split #"\W+")))

(defn word-count [phrase]
  (-> (sanitize-and-split phrase)
      (frequencies)))
