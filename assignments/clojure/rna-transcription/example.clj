(ns dna)

(def dna->rna {
      \C \G
      \G \C
      \A \U
      \T \A})

(defn validate-strand [strand]
  (let [valid-dna (set (keys dna->rna))]
    (every? valid-dna strand)))

(defn to-rna
  [strand]
  {:pre [(validate-strand strand)]}
  (apply str
    (map dna->rna (seq strand))))
