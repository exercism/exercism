(ns bob
  (require [clojure.string :as str]))

(defn- silence?  [msg] (= msg ""))
(defn- shouting? [msg] (= msg (str/upper-case msg)))
(defn- question? [msg] (= \? (last msg)))

(defn response-for [input]
  (cond
    (silence?  input) "Fine, be that way."
    (shouting? input) "Woah, chill out!"
    (question? input) "Sure."
    :else             "Whatever."))
