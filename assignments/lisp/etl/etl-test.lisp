(ql:quickload "lisp-unit")

(cl:defpackage #:etl-test
  (:use :common-lisp :lisp-unit))

(load "etl")

(in-package :etl-test)

(defun make-hash (kvs)
  (reduce 
   #'(lambda (h kv) (setf (gethash (first kv) h) (second kv)) h)
   kvs
   :initial-value (make-hash-table :test 'equalp)))

;; useful for debugging
(defmethod print-object ((object hash-table) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "(")
    (maphash #'(lambda (k v) (format stream "(~S: ~S)" k v)) object)
    (format stream ")")))

(define-test transform-one-value
  (assert-equalp (make-hash '(("world" 1)))
      (etl:transform (make-hash '((1 ("WORLD")))))))

(define-test transform-more-values
  (assert-equalp (make-hash '(("world" 1) ("gschoolers" 1)))
      (etl:transform (make-hash '((1 ("WORLD" "GSCHOOLERS")))))))

(define-test more-keys
  (assert-equalp (make-hash '(("apple" 1) ("artichoke" 1) ("boat" 2) ("ballerina" 2)))
      (etl:transform (make-hash '((1 ("APPLE" "ARTICHOKE")) (2 ("BOAT" "BALLERINA")))))))

(define-test full-dataset
  (let ((input-data '((1 ("A" "E" "I" "O" "U" "L" "N" "R" "S" "T"))
		      (2 ("D" "G"))
		      (3 ("B" "C" "M" "P"))
		      (4 ("F" "H" "V" "W" "Y"))
		      (5 ("K"))
		      (8 ("J" "X"))
		      (10 ("Q" "Z"))))
	(expected-output '(("a" 1) ("b" 3) ("c" 3) ("d" 2) ("e" 1) 
			   ("f" 4) ("g" 2) ("h" 4) ("i" 1) ("j" 8)
			   ("k" 5) ("l" 1) ("m" 3) ("n" 1) ("o" 1)
			   ("p" 3) ("q" 10) ("r" 1) ("s" 1) ("t" 1)
			   ("u" 1) ("v" 4) ("w" 4) ("x" 8) ("y" 4)
			   ("z" 10))))
    (assert-equalp (make-hash expected-output) 
	(etl:transform (make-hash input-data)))))

(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all :etl-test))
