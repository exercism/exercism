(ql:quickload "lisp-unit")

(cl:defpackage #:beer-song-test
  (:use :common-lisp :lisp-unit))

(load "beer")

(in-package :beer-song-test)

(defparameter +verse-8+ 
  "8 bottles of beer on the wall, 8 bottles of beer.
Take one down and pass it around, 7 bottles of beer on the wall.
")
(defparameter +verse-2+ 
  "2 bottles of beer on the wall, 2 bottles of beer.
Take one down and pass it around, 1 bottle of beer on the wall.
")
(defparameter +verse-1+ 
  "1 bottle of beer on the wall, 1 bottle of beer.
Take it down and pass it around, no more bottles of beer on the wall.
")
(defparameter +verse-0+ 
  "No more bottles of beer on the wall, no more bottles of beer.
Go to the store and buy some more, 99 bottles of beer on the wall.
")

(defparameter +song-8-6+ 
  "8 bottles of beer on the wall, 8 bottles of beer.
Take one down and pass it around, 7 bottles of beer on the wall.

7 bottles of beer on the wall, 7 bottles of beer.
Take one down and pass it around, 6 bottles of beer on the wall.

6 bottles of beer on the wall, 6 bottles of beer.
Take one down and pass it around, 5 bottles of beer on the wall.

")
(defparameter +song-3-0+ 
  "3 bottles of beer on the wall, 3 bottles of beer.
Take one down and pass it around, 2 bottles of beer on the wall.

2 bottles of beer on the wall, 2 bottles of beer.
Take one down and pass it around, 1 bottle of beer on the wall.

1 bottle of beer on the wall, 1 bottle of beer.
Take it down and pass it around, no more bottles of beer on the wall.

No more bottles of beer on the wall, no more bottles of beer.
Go to the store and buy some more, 99 bottles of beer on the wall.

")

(define-test test-verse
  (assert-equal +verse-8+ (beer:verse 8))
  (assert-equal +verse-2+ (beer:verse 2))
  (assert-equal +verse-1+ (beer:verse 1)))

(define-test test-song
  (assert-equal +song-8-6+ (beer:sing 8 6))
  (assert-equal +song-3-0+ (beer:sing 3)))

(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all :beer-song-test))

