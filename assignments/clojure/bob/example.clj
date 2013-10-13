(ns bob
  (require [clojure.string :as str]))

(defn- silence?    [msg] (str/blank? msg))

(defn- question?   [msg] (= \? (last msg)))

(defn- has-letter? [msg] (some #(or (Character/isUpperCase %)
                                    (Character/isLowerCase %)) msg))

(defn- shouting?   [msg] (and (= msg (str/upper-case msg))
                              (has-letter? msg)))

(defn response-for [input]
  (cond
    (silence?  input) "Fine. Be that way!"
    (shouting? input) "Woah, chill out!"
    (question? input) "Sure."
    :else             "Whatever."))
