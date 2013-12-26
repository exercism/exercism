(ql:quickload "lisp-unit")

(cl:defpackage :rna-transcription-test
  (:use :common-lisp :lisp-unit))

(load "dna")

(in-package :rna-transcription-test)

(define-test transcribes-cytidine-unchanged
  (assert-equal "C" (dna:to-rna "C")))

(define-test transcribes-guanosine-unchanged
  (assert-equal "G" (dna:to-rna "G")))

(define-test transcribes-adenosine-unchanged
  (assert-equal "A" (dna:to-rna "A")))

(define-test it-transcribes-thymidine-to-uracil
  (assert-equal "U" (dna:to-rna "T")))

(define-test it-transcribes-all-occurrences-of-thymidine-to-uracil
  (assert-equal "ACGUGGUCUUAA" (dna:to-rna "ACGTGGTCTTAA")))

(define-test it-validates-dna-strands
  (assert-error 'error (dna:to-rna "XCGFGGTDTTAA")))

(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all :rna-transcription-test))
