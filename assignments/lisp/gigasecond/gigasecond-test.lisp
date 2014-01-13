(ql:quickload "lisp-unit")

(cl:defpackage #:gigasecond-test
  (:use :cl :lisp-unit))

(load "gigasecond")

(in-package :gigasecond-test)

(define-test from-apr-25-2011
  (assert-equal '(2043 1 1) (gigasecond:from 2011 4 25)))

(define-test from-jun-13-1977
  (assert-equal '(2009 2 19) (gigasecond:from 1977 6 13)))

(define-test from-jul-19-1959
  (assert-equal '(1991 3 27) (gigasecond:from 1959 7 19)))

; customize this to test your birthday and find your gigasecond date:
; (define-test your-birthday
;   (assert-equal '(year2 month2 day2) (gigasecond:from year1 month1 day1)))

(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all :gigasecond-test))
