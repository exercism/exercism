(ql:quickload "lisp-unit")

(cl:defpackage #:grade-school-test
  (:use :common-lisp :lisp-unit))

(load "school")

(in-package :grade-school-test)

(defmethod print-object ((object hash-table) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "(") 
    (maphash #'(lambda (k v) (format stream "(~S . ~S)" k v)) object)
    (format stream ")")))

(defun make-hash (kvs)
  (reduce 
   #'(lambda (h kv) (setf (gethash (first kv) h) (second kv)) h)
   kvs
   :initial-value (make-hash-table)))

(define-test grade-roster-is-initially-empty
  (let ((school (make-instance 'school:school)))  
    (assert-equalp (make-hash-table) (school:grade-roster school))))

(define-test add-student
  (let ((school (make-instance 'school:school)))
    (school:add school "Aimee" 2)
    (assert-equalp (make-hash '((2 ("Aimee")))) 
	(school:grade-roster school))))

(define-test add-more-students-in-same-class
  (let ((school (make-instance 'school:school)))  
    (school:add school "James" 2)
    (school:add school "Blair" 2)
    (school:add school "Paul" 2)
    (assert-equalp (make-hash '((2 ("James" "Blair" "Paul")))) 
	(school:grade-roster school))))

(define-test add-students-to-different-grades
  (let ((school (make-instance 'school:school)))
    (school:add school "Chelsea" 3)
    (school:add school "Logan" 7)
    (assert-equalp 
	(make-hash '((3 ("Chelsea")) (7 ("Logan"))))
	(school:grade-roster school))))

(define-test get-students-in-a-grade
  (let ((school (make-instance 'school:school)))
    (school:add school "Franklin" 5)
    (school:add school "Bradley" 5)
    (school:add school "Jeff" 1)
    (assert-equalp '("Franklin" "Bradley")
	(school:grade school 5))))

(define-test get-students-in-a-non-existant-grade
  (let ((school (make-instance 'school:school)))
    (assert-equalp '() (school:grade school 1))))

(define-test sorted-school
  (let ((school (make-instance 'school:school)))
    (school:add school "Jennifer" 4)
    (school:add school "Kareem" 6)
    (school:add school "Christopher" 4)
    (school:add school "Kyle" 3)
    (assert-equalp '((3 ("Kyle"))
		     (4 ("Christopher" "Jennifer"))
		     (6 ("Kareem")))
	(school:sorted school))))

(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all :grade-school-test))

