(ns drops
  (:require [clojure.string :refer [blank?]]))

(def ^:private sound-map
  { 3 "Pling"
    5 "Plang"
    7 "Plong" })

(defn- divisors
  [number]
  (filter
    (fn [[div sound]]
      (zero? (rem number div)))
    sound-map))

(defn- sounds-for
  [number]
  (let [divisors (divisors number)
        sounds (map last divisors)]
    (apply str sounds)))

(defn convert
  [number]
  (let [sounds (sounds-for number)]
    (if (blank? sounds)
      (str number)
      sounds)))
