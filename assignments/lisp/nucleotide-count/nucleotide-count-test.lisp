(ql:quickload "lisp-unit")

(cl:defpackage #:nucleotide-count-test
  (:use :common-lisp :lisp-unit))

(load "dna")

(in-package :nucleotide-count-test)

(defun make-hash (kvs)
  (reduce 
   #'(lambda (h kv) (setf (gethash (first kv) h) (second kv)) h)
   kvs
   :initial-value (make-hash-table)))

(define-test empty-dna-strand-has-no-adenosine
  (assert-equal 0 (dna:dna-count #\A "")))

(define-test empty-dna-strand-has-no-nucleotides
  (assert-equalp (make-hash '((#\A 0) (#\T 0) (#\C 0) (#\G 0)))
      (dna:nucleotide-counts "")))

(define-test repetitive-cytidine-gets-counted
  (assert-equal 5 (dna:dna-count #\C "CCCCC")))

(define-test repetitive-sequence-has-only-guanosine
  (assert-equalp (make-hash '((#\A 0) (#\T 0) (#\C 0) (#\G 8)))
      (dna:nucleotide-counts "GGGGGGGG")))

(define-test counts-only-thymidine
  (assert-equal 1 (dna:dna-count #\T "GGGGGTAACCCGG")))

(define-test dna-has-no-uracil
  (assert-equal 0 (dna:dna-count #\U "GATTACA")))

(define-test validates-nucleotides
  (assert-error 'dna:invalid-nucleotide (dna:dna-count #\X "GACT")))

(define-test counts-all-nucleotides
  (assert-equalp (make-hash '((#\A 20) (#\T 21) (#\G 17) (#\C 12)))
      (dna:nucleotide-counts 
       "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC")))

(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all :nucleotide-count-test))
