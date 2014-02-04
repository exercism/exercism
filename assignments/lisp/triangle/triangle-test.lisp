(ql:quickload "lisp-unit")

(cl:defpackage #:triangle-test
  (:use :cl :lisp-unit))

(load "triangle")

(in-package :triangle-test)

(define-test equilateral-1
  (assert-equal  :equilateral (triangle:triangle 2 2 2)))
(define-test equilateral-2
  (assert-equal  :equilateral (triangle:triangle 10 10 10)))
(define-test isoceles-1
  (assert-equal  :isosceles (triangle:triangle 3 4 4)))
(define-test isoceles-2
  (assert-equal  :isosceles (triangle:triangle 4 3 4)))
(define-test scalene
  (assert-equal  :scalene (triangle:triangle 3 4 5)))
(define-test invalid-1
  (assert-equal  :illogical (triangle:triangle 1 1 50)))
(define-test invalid-2
  (assert-equal  :illogical (triangle:triangle 1 2 1)))

(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all :triangle-test))

