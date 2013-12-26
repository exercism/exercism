(ql:quickload "lisp-unit")

(cl:defpackage #:word-count-test
  (:use :common-lisp :lisp-unit))

(load "word-count")

(in-package :word-count-test)

(defun assert-assoc-equal (expected actual)
  "The association lists must have the same length and the keys and
  values of the items must match. But the order is not
  important. Equality is tested with equal"
  (assert-equal 
      (sort expected #'string< :key #'car)
      (sort actual #'string< :key #'car)))

(define-test count-one-word
  (assert-assoc-equal '(("word" . 1))
      (phrase:word-count "word")))

(define-test count-one-of-each
  (assert-assoc-equal '(("one" . 1) ("of" . 1) ("each" . 1))
      (phrase:word-count "one of each")))

(define-test count-multiple-occurrences
  (assert-assoc-equal 
   '(("one" . 1) ("fish" . 4) ("two". 1) ("red" . 1) ("blue" . 1))
   (phrase:word-count "one fish two fish red fish blue fish")))

(define-test ignore-punctuation
  (assert-assoc-equal 
   '(("car" . 1) ("carpet" . 1) ("as" . 1) ("java" . 1) ("javascript" . 1))
   (phrase:word-count "car : carpet as java : javascript!!&@$%^&")))

(define-test include-numbers
  (assert-assoc-equal '(("testing" . 2) ("1" . 1) ("2" . 1))
      (phrase:word-count "testing, 1, 2 testing")))

(define-test normalize-case
  (assert-assoc-equal '(("go" . 3) ("on" . 3))
	  (phrase:word-count "go ON Go On GO on")))

(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all :word-count-test))
