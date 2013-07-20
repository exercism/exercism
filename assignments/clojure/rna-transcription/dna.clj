(ns dna)

(defn to-rna
  [strand]
  (clojure.string/replace strand #"T" "U"))
