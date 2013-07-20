(ns nucleotide-count.test (:use clojure.test))
(load-file "dna.clj")

(deftest empty-dna-strand-has-no-adenosine
  (is (= 0 (dna/count "A", ""))))

(deftest empty-dna-strand-has-no-nucleotides
  (is (= {"A" 0 "T" 0 "C" 0 "G" 0}
         (dna/nucleotide-counts ""))))

(deftest repetitive-cytidine-gets-counted
  (is (= 5 (dna/count "C" "CCCCC"))))

(deftest repetitive-sequence-has-only-guanosine
  (is (= {"A" 0 "T" 0 "C" 0 "G" 8}
         (dna/nucleotide-counts "GGGGGGGG"))))

(deftest counts-only-thymidine
  (is (= 1 (dna/count "T" "GGGGGTAACCCGG"))))

(deftest dna-has-no-uracil
  (is (= 0 (dna/count "U" "GATTACA"))))

(deftest validates-nucleotides
  (is (thrown-with-msg? Exception #"invalid nucleotide" (dna/count "X" "GACT"))))

(deftest counts-all-nucleotides
  (let [s "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC"]
    (is (= {"A" 20 "T" 21 "G" 17 "C" 12}
           (dna/nucleotide-counts s)))))

(run-tests)
