(cl:defpackage #:phone
  (:use :common-lisp)
  (:export :numbers :area-code :pretty-print))

(in-package :phone)

(defun is-digit-p (c) (char<= #\0 c #\9))

(defun strip-non-digits (string)
  (remove-if-not #'is-digit-p string))

(defun trim-leading-one (string)
  (if (and (= 11 (length string))
	   (equal #\1 (char string 0)))
      (subseq string 1)
      string))

(defun ensure-valid (string)
  (if (= 10 (length string)) string "0000000000"))

(defun numbers (number-string)
  (reduce #'(lambda (s fn) (funcall fn s))
	  '(strip-non-digits trim-leading-one ensure-valid)
	  :initial-value number-string))

(defun area-code (number-string)
  (subseq (numbers number-string) 0 3))

(defun exchange (number-string)
  (subseq (numbers number-string) 3 6))

(defun subscriber (number-string)
  (subseq (numbers number-string) 6 10))

(defun pretty-print (number-string)
  (format nil "(~D) ~D-~D"
	  (area-code number-string)
	  (exchange number-string)
	  (subscriber number-string)))
