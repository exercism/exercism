(ns dna)

(def thymine \T)
(def uracil  \U)

(defn to-rna
  [strand]
  (clojure.string/replace strand thymine uracil))
