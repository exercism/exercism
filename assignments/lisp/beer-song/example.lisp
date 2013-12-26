(cl:defpackage #:beer
  (:use :common-lisp)
  (:export :verse :sing))

(in-package :beer)

(defgeneric bottles (n))
(defmethod bottles (n) (format nil "~A bottle~:P" n))
(defmethod bottles ((n (eql 0))) (bottles "no more"))

(defgeneric left (n))
(defmethod left ((n integer)) (1- n))
(defmethod left ((n (eql 0))) 99)

(defgeneric pronoun (n))
(defmethod pronoun ((n integer)) "one")
(defmethod pronoun ((n (eql 1))) "it")

(defmethod action (n))
(defmethod action ((n integer))
  (format nil "Take ~A down and pass it around" (pronoun n)))
(defmethod action ((n (eql 0)))
  "Go to the store and buy some more")

(defun verse (n)
  (format nil 
	  "~@(~A~)~:* of beer on the wall, ~A of beer.~%~
           ~A, ~A of beer on the wall.~%"
	  (bottles n) (action n) (bottles (left n))))

(defun sing (start &optional (end 0))
  (format nil 
	  "~{~A~^~%~}~%"
	  (loop for n from start downto end
	     collecting (verse n))))
