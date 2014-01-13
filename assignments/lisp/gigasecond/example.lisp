(cl:defpackage #:gigasecond
  (:use :cl)
  (:export :from))

(in-package :gigasecond)

(defun from (year month day)
  (reverse 
   (subseq 
    (multiple-value-list  
     (decode-universal-time
      (+ (encode-universal-time 0 0 0 day month year)
	 (expt 10 9))))
    3 6)))
