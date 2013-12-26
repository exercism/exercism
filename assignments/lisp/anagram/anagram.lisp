(cl:defpackage #:anagram
  (:use :common-lisp)
  (:export :anagrams-for))

(in-package :anagram)

(defun anagram-equal (a b)
  (and 
   (string-equal (sort (copy-seq a) #'char-lessp) 
		 (sort (copy-seq b) #'char-lessp))
   (string-not-equal a b)))

(defun anagrams-for (subject candidates)
  (remove-if-not 
   #'(lambda (w) (anagram-equal w subject)) 
   candidates))
