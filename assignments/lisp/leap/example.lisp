(cl:defpackage #:leap
  (:use :common-lisp)
  (:export :leap-year-p))

(in-package :leap)

(defun divisible-by-p (n d) (= 0 (rem n d)))

(defun leap-year-p (year)
  (and (divisible-by-p year 4)
       (or (not (divisible-by-p year 100))
	   (divisible-by-p year 400))))
