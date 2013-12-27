(cl:defpackage #:robot
  (:use :common-lisp)
  (:export :build-robot :robot-name :reset-name))

(in-package :robot)

;;; useful for debugging
(defmethod print-object ((object robot) stream)
  (print-unreadable-object (object stream :type t)
    (write (robot-name object) :stream stream)))

(defun random-alpha-char ()
  (code-char (+ (char-code #\A) (random 26))))
(defun random-digit-char ()
  (code-char (+ (char-code #\0) (random 10))))

(defun random-robot-name ()
  (concatenate 'string (list (random-alpha-char)
			     (random-alpha-char)
			     (random-digit-char)
			     (random-digit-char)
			     (random-digit-char))))

(defun build-robot () (make-instance 'robot))
(defclass robot ()
  ((name :reader robot-name :initform (random-robot-name))))
(defun reset-name (robot)
  (setf (slot-value robot 'name) (random-robot-name)))
