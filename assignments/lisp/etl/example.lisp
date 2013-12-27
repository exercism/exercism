(cl:defpackage #:etl
  (:use :common-lisp)
  (:export :transform))

(in-package :etl)

(defun transform (data)
  (let ((old-kvs (loop 
		for k being each hash-keys in data
		for v being each hash-values in data
		collecting (list k v))))
    (reduce
     #'(lambda (h kv) 
	 (loop 
	    for v in (second kv)
	    with k = (first kv)
	    do (setf (gethash v h) k)
	    finally (return h)))
     old-kvs
     :initial-value (make-hash-table :test 'equalp)))
  )
