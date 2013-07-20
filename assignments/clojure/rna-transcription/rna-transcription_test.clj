(ns rna-transcription.test (:use clojure.test))
(load-file "dna.clj")

(deftest transcribes-cytidine-unchanged
  (is (= "C" (dna/to-rna "C"))))

(deftest transcribes-guanosine-unchanged
  (is (= "G" (dna/to-rna "G"))))

(deftest transcribes-adenosine-unchanged
  (is (= "A" (dna/to-rna "A"))))

(deftest it-transcribes-thymidine-to-uracil
  (is (= "U" (dna/to-rna "T"))))

(deftest it-transcribes-all-occurrences-of-thymidine-to-uracil
  (is (= "ACGUGGUCUUAA" (dna/to-rna "ACGTGGTCTTAA"))))

(run-tests)
