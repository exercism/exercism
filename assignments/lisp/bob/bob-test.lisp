(ql:quickload "lisp-unit")

(cl:defpackage #:bob-test
  (:use :common-lisp :lisp-unit))

(load "bob")

(in-package :bob-test)

(define-test responds-to-something
  (assert-equal "Whatever." (bob:response-for "Tom-ay-to, tom-aaaah-to.")))

(define-test responds-to-shouts
  (assert-equal "Woah, chill out!" (bob:response-for "WATCH OUT!")))

(define-test responds-to-questions
  (assert-equal "Sure." (bob:response-for "Does this cryogenic chamber make me look fat?")))

(define-test responds-to-forceful-talking
  (assert-equal "Whatever." (bob:response-for "Let's go make out behind the gym!")))

(define-test responds-to-acronyms
  (assert-equal "Whatever." (bob:response-for "It's OK if you don't want to go to the DMV.")))

(define-test responds-to-forceful-questions
  (assert-equal "Woah, chill out!" (bob:response-for "WHAT THE HELL WERE YOU THINKING?")))

(define-test responds-to-shouting-with-special-characters
  (assert-equal "Woah, chill out!" (bob:response-for "ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!")))

(define-test responds-to-shouting-numbers
  (assert-equal "Woah, chill out!" (bob:response-for "1, 2, 3 GO!")))

(define-test responds-to-shouting-with-no-exclamation-mark
  (assert-equal "Woah, chill out!" (bob:response-for "I HATE YOU")))

(define-test responds-to-statement-containing-question-mark
  (assert-equal "Whatever." (bob:response-for "Ending with ? means a question.")))

(define-test responds-to-silence
  (assert-equal "Fine. Be that way!" (bob:response-for "")))

(define-test responds-to-prolonged-silence
  (assert-equal "Fine. Be that way!" (bob:response-for "    ")))

(define-test responds-to-only-numbers
  (assert-equal "Whatever." (bob:response-for "1, 2, 3")))

(define-test responds-to-number-question
  (assert-equal "Sure." (bob:response-for "4?")))

(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all))
