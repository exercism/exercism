(cl:defpackage #:grains
  (:use :cl)
  (:export :square :total))

(in-package :grains)

(defun square (n) (expt 2 (1- n)))

(defun total ()
  (loop for n from 1 to 64 summing (square n)))
