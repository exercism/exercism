(cl:defpackage #:phrase
  (:use :common-lisp)
  (:export :word-count))

(in-package :phrase)

(defun split-string (string)
  (labels ((split-string-iter (string result)
	     (let ((idx (position #\Space string :from-end t)))
	       (if idx 
		   (split-string-iter (subseq string 0 idx)
				      (cons (subseq string (1+ idx)) result))
		   (cons string result)))))
    (split-string-iter string (list))))

(defun remove-empty-strings (string-list)
  (remove "" string-list :test #'string=))

(defun strip-punctuation (string)
  (remove-if-not #'(lambda (c)
		     (or (char-not-greaterp #\0 c #\9)
			 (char-not-greaterp #\a c #\z)
			 (char= c #\Space)))
	     string))

(defun word-count (sentence)
  (let ((words (remove-empty-strings 
		(split-string 
		 (strip-punctuation 
		  (string-downcase sentence))))))
    (mapcar #'(lambda (w) (cons w (count w words :test #'string=)))
	    (remove-duplicates words :test #'string=))))
