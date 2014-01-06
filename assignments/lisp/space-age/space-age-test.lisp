(ql:quickload "lisp-unit")

(defpackage #:space-age-test
  (:use :common-lisp :lisp-unit))

(load "space-age")

(in-package :space-age-test)

(defun rounds-to (expected actual)
  (flet ((to-2-places (n) (/ (fround (* 100 n)))))
    (assert-equal (to-2-places expected)
			(to-2-places actual))))

(define-test age-in-earth-years
  (rounds-to 31.69 (space-age:on-earth 1000000001)))

(define-test age-in-mercury-years
  (let ((seconds 2134835688))
    (rounds-to 67.65 (space-age:on-earth seconds))
    (rounds-to 280.88 (space-age:on-mercury seconds))))

(define-test age-in-venus-years
  (let ((seconds 189839836))
    (rounds-to 6.02 (space-age:on-earth seconds))
    (rounds-to 9.78 (space-age:on-venus seconds))))

(define-test age-on-mars
  (let ((seconds 2329871239))
    (rounds-to 73.83 (space-age:on-earth seconds))
    (rounds-to 39.25 (space-age:on-mars seconds))))

(define-test age-on-jupiter
  (let ((seconds 901876382))
    (rounds-to 28.58 (space-age:on-earth seconds))
    (rounds-to 2.41 (space-age:on-jupiter seconds))))

(define-test age-on-saturn
  (let ((seconds 3000000000))
    (rounds-to 95.06 (space-age:on-earth seconds))
    (rounds-to 3.23 (space-age:on-saturn seconds))))

(define-test age-on-uranus
  (let ((seconds 3210123456))
    (rounds-to 101.72 (space-age:on-earth seconds))
    (rounds-to 1.21 (space-age:on-uranus seconds))))

(define-test age-on-neptune
  (let ((seconds 8210123456))
    (rounds-to 260.16 (space-age:on-earth seconds))
    (rounds-to 1.58 (space-age:on-neptune seconds))))

(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all :space-age-test))
