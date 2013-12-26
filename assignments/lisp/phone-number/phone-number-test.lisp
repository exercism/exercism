(ql:quickload "lisp-unit")

(cl:defpackage #:phone-number-test
  (:use :common-lisp :lisp-unit))

(load "phone")

(in-package :phone-number-test)

(define-test cleans-number
  (assert-equal "1234567890" (phone:numbers "(123) 456-7890")))

(define-test cleans-number-with-dots
  (assert-equal "1234567890" (phone:numbers "123.456.7890")))

(define-test valid-when-11-digits-and-first-is-1
  (assert-equal "1234567890" (phone:numbers "11234567890")))

(define-test invalid-when-11-digits
  (assert-equal "0000000000" (phone:numbers "21234567890")))

(define-test invalid-when-9-digits
  (assert-equal "0000000000" (phone:numbers "123456789")))

(define-test area-code
  (assert-equal "123" (phone:area-code "1234567890")))

(define-test pretty-print
  (assert-equal "(123) 456-7890" (phone:pretty-print "1234567890")))

(define-test pretty-print-with-full-us-phone-number
  (assert-equal "(123) 456-7890" (phone:pretty-print "11234567890")))

(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all :phone-number-test))
