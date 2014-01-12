(ql:quickload "lisp-unit")

(cl:defpackage #:grains-test
  (:use :cl :lisp-unit))

(load "grains")

(in-package :grains-test)

(define-test square-1
  (assert-equal 1 (grains:square 1)))

(define-test square-2
  (assert-equal 2 (grains:square 2)))

(define-test square-3
  (assert-equal 4 (grains:square 3)))

(define-test square-4
  (assert-equal 8 (grains:square 4)))

(define-test square-16
  (assert-equal 32768 (grains:square 16)))

(define-test square-32
  (assert-equal 2147483648 (grains:square 32)))

(define-test square-64
  (assert-equal 9223372036854775808 (grains:square 64)))

(define-test total-grains
  (assert-equal 18446744073709551615  (grains:total)))

(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all :grains-test))

