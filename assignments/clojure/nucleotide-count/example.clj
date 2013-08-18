(ns dna
  (:refer-clojure :exclude [count]))

(def ^{:private :const} dna-nucleotide? #{\A \C \G \T})
(def ^{:private :const} rna-nucleotide? #{\A \C \G \U})

(def ^{:private :const} base-count
  (apply hash-map (interleave dna-nucleotide? (repeat 0))))

(defn nucleotide-counts
  "generate a map of counts per nucleotide in strand"
  [strand]
  (into base-count (frequencies strand)))

(defn count
  "count occurrences of nucleotide in strand"
  [nucleotide strand]
  (cond
    (dna-nucleotide? nucleotide) ((nucleotide-counts strand) nucleotide)
    (rna-nucleotide? nucleotide) 0
    :else (throw (Exception. (str "invalid nucleotide '" nucleotide "'")))))
