(cl:defpackage #:dna
  (:use :common-lisp)
  (:export :dna-count :nucleotide-counts :invalid-nucleotide))

(in-package :dna)

(define-condition invalid-nucleotide (error) ())

(defparameter +dna-nucleotides+ "ACTG")
(defparameter +valid-nucleotides+ (concatenate 'string +dna-nucleotides+ "U"))

(defun validate-nucleotide (nucleotide)
  (or (find nucleotide +valid-nucleotides+)
      (error 'invalid-nucleotide)))

(defun dna-count (nucleotide strand)
  (validate-nucleotide nucleotide)
  (count nucleotide strand))

(defun nucleotide-counts (strand)
  (reduce #'(lambda (h c) (setf (gethash c h) (dna-count c strand)) h)
	  +dna-nucleotides+
	  :initial-value (make-hash-table)))
