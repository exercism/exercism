(cl:defpackage #:school
  (:use :common-lisp)
  (:export :school :add :grade-roster :grade :sorted))

(in-package :school)

(defclass school () 
  ((grade-roster :reader grade-roster :initform (make-hash-table))))

(defun add (school student grade)
 (setf (grade school grade) 
       (append (grade school grade) (list student))))

(defun grade (school grade)
  (gethash grade (grade-roster school)))

(defun (setf grade) (new-value school grade)
  (setf (gethash grade (grade-roster school)) new-value))

(defun sorted (school)
  (sort (loop 
	   for k being the hash-keys of (grade-roster school)
	   collecting (list k (sort (grade school k) #'string<)))
	#'<
	:key #'first))
