(ql:quickload "lisp-unit")

(cl:defpackage #:anagram-test
  (:use :common-lisp :lisp-unit))

(load "anagram")

(in-package :anagram-test)

(define-test no-matches
  (assert-equal '() 
      (anagram:anagrams-for 
       "diaper" 
       '("hello" "world" "zombies" "pants"))))

(define-test detect-simple-anagram
  (assert-equal '("tan") 
      (anagram:anagrams-for "ant" '("tan" "stand" "at"))))

(define-test does-not-confuse-different-duplicates
  (assert-equal '() (anagram:anagrams-for "galea" '("eagle"))))

(define-test eliminate-anagram-subsets
  (assert-equal '() (anagram:anagrams-for "good" '("dog" "goody"))))

(define-test detect-anagram
  (assert-equal '("inlets") 
      (anagram:anagrams-for 
       "listen" 
       '("enlists" "google" "inlets" "banana"))))

(define-test multiple-anagrams
  (assert-equal '("gallery" "regally" "largely")
      (anagram:anagrams-for 
       "allergy" 
       '("gallery" "ballerina" "regally" "clergy" "largely" "leading"))))

(define-test case-insensitive-anagrams
  (assert-equal '("Carthorse")
      (anagram:anagrams-for 
       "Orchestra" 
       '("cashregister" "Carthorse" "radishes"))))

(define-test word-is-not-own-anagram
  (assert-equal '() 
      (anagram:anagrams-for "banana" '("banana"))))

(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all :anagram-test))
