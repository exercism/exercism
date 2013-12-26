(cl:defpackage #:dna
  (:use :common-lisp)
  (:export :to-rna))

(in-package :dna)

(defun validate-strand (strand)
  (or (every #'(lambda (c) (find c "ATCGU"))
	     (coerce strand 'list))
      (signal 'error)))

(defun to-rna (strand)
  (validate-strand strand)
  (substitute #\U #\T strand))
