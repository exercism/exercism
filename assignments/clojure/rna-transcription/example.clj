(ns dna)

(def adenosine \A)
(def cytadine  \C)
(def guanosine \G)
(def thymidine \T)
(def uracil    \U)

(defn to-rna
  [strand]
  {:pre [(every? #{adenosine cytadine guanosine thymidine}
                 (set strand))]}
  (clojure.string/replace strand thymidine uracil))
