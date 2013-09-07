(ns dna)

(def thymidine \T)
(def uracil    \U)

(defn to-rna
  [strand]
  (clojure.string/replace strand thymidine uracil))
