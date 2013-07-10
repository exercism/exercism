(ns bob)

(def question  (partial re-matcher #"\?$"))
(def statement (partial re-matcher #"\.$"))

(defn response-for [input]
  (cond
    (= input "")                   "Fine, be that way."
    (= input (.toUpperCase input)) "Woah, chill out!"
    (re-find (question input))     "Sure."
    (re-find (statement input))    "Whatever."
  ))
