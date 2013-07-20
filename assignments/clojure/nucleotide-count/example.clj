(ns dna)

(def dna-nucleotides ["A" "T" "C" "G"])
(def rna-nucleotides ["U"])
(def nucleotides (into dna-nucleotides rna-nucleotides))

(defn- in?
  "true if seq contains elm"
  [seq elm]
  (some #(= elm %) seq))

(defn count
  "count occurrences of nucleotide in strand"
  [nucleotide strand]
  (if (in? nucleotides nucleotide)
    (->> (clojure.string/split strand #"")
         (filter #(= nucleotide %1))
         clojure.core/count)
    (throw (Exception. (str "invalid nucleotide '" nucleotide "'")))))

(defn nucleotide-counts
  "generate a map of counts per nucleotide in strand"
  [strand]
  (reduce
    #(assoc %1 %2 (count %2 strand))
    {} dna-nucleotides))
