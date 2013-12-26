(ql:quickload "lisp-unit")

(cl:defpackage #:point-mutations-test
  (:use :common-lisp :lisp-unit))

(load "dna")

(in-package :point-mutations-test)

(define-test no-difference-between-empty-strands
  (assert-equal 0 (dna:hamming-distance "" "")))

(define-test no-difference-between-identical-strands
  (assert-equal 0 (dna:hamming-distance "GGACTGA" "GGACTGA")))

(define-test complete-hamming-distance-in-small-strand
  (assert-equal 3 (dna:hamming-distance "ACT" "GGA")))

(define-test hamming-distance-in-off-by-one-strand
  (assert-equal 19 (dna:hamming-distance "GGACGGATTCTGACCTGGACTAATTTTGGGG" "AGGACGGATTCTGACCTGGACTAATTTTGGGG")))

(define-test small-hamming-distance-in-middle-somewhere
  (assert-equal 1 (dna:hamming-distance "GGACG" "GGTCG")))

(define-test larger-distance
  (assert-equal 2 (dna:hamming-distance "ACCAGGG" "ACTATGG")))

(define-test ignores-extra-length-on-other-strand-when-longer
  (assert-equal 3 (dna:hamming-distance "AAACTAGGGG" "AGGCTAGCGGTAGGAC")))

(define-test ignores-extra-length-on-original-strand-when-longer
  (assert-equal 5 (dna:hamming-distance "GACTACGGACAGGGTAGGGAAT" "GACATCGCACACC")))

(define-test does-not-actually-shorten-original-strand
  (assert-equal 1 (dna:hamming-distance "AGACAACAGCCAGCCGCCGGATT" "AGGCAA"))
  (assert-equal 4 (dna:hamming-distance "AGACAACAGCCAGCCGCCGGATT" "AGACATCTTTCAGCCGCCGGATTAGGCAA"))
  (assert-equal 1 (dna:hamming-distance "AGACAACAGCCAGCCGCCGGATT" "AGG")))

(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all :point-mutations-test))

