(ns etl)
(require '[clojure.string :refer [lower-case]])

(defn transform [m]
  (into {}
    (apply concat (for [[k vs] m]
      (for [v vs]
        [(lower-case v) k])))))
