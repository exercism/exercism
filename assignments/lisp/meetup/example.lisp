(cl:defpackage #:meetup
  (:use :common-lisp))

(in-package :meetup)

(defun day-of-week (day month year)
  (nth 6 (multiple-value-list
	  (decode-universal-time
	   (encode-universal-time 0 0 0 day month year)))))

(defun last-day-of (month year)
  (let ((month (if (= month 12) 1 (1+ month)))
	(year (if (= month 12) (1+ year) year)))
    (nth 3 (multiple-value-list
	    (decode-universal-time
	     (1- (encode-universal-time 0 0 0 1 month year)))))))

(defun find-dow-near-date (target-dow direction day month year)
  (let ((direction-factor (* 7 (ecase direction (:before -1) (:after 1))))
	(dow-of-day (day-of-week day month year)))
    (list year month (+ day (rem (+ (- target-dow dow-of-day) 
				    direction-factor) 
				 7)))))

(defvar +days-of-the-week+ '(("monday" 0)
			     ("tuesday" 1)
			     ("wednesday" 2)
			     ("thursday" 3)
			     ("friday" 4)
			     ("saturday" 5)
			     ("sunday" 6)))

(defvar +ordinals+ '(("first" 1)
		     ("second" 2)
		     ("third" 3)
		     ("fourth" 4)))

(defun strcat (&rest strs)
  (apply #'concatenate 'string strs))

(defun make-exported-fn (name fn)
  (let ((sym (intern (string-upcase name))))
    (setf (symbol-function sym) fn)
    (export sym)))

;; create the *teenth functions
(dolist (dow +days-of-the-week+)
  (labels ((teenth-ify (dow) (strcat (subseq dow 0 (- (length dow) 3)) "teenth")))
    (make-exported-fn (teenth-ify (first dow))
		      #'(lambda (month year)
			  (find-dow-near-date (second dow) 
					      :after 13 month year)))))

;; create the ordinal-dow functions
(dolist (dow +days-of-the-week+)
  (dolist (ordinal +ordinals+)
    (make-exported-fn (strcat (first ordinal) "-" (first dow))
		      #'(lambda (month year)
			  (find-dow-near-date (second dow) 
					      :after
					      (1+ (* 7 (1- (second ordinal))))
					      month year)))))

;; create the last-dow functions
(dolist (dow +days-of-the-week+)
  (make-exported-fn (strcat "last-" (first dow))
		    #'(lambda (month year)
			(find-dow-near-date (second dow) 
					    :before
					    (last-day-of month year)
					    month year))))
