(cl:defpackage #:triangle
  (:use :cl)
  (:export :triangle))

(in-package :triangle)

(defun triangle (a b c)
  (let ((sorted (sort (list a b c) #'>)))
    (if (>= (first sorted) (apply #'+ (rest sorted))) :illogical
	(case (length (remove-duplicates sorted))
	  (1 :equilateral)
	  (2 :isosceles)
	  (3 :scalene)))))
