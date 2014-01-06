(ql:quickload "lisp-unit")

(cl:defpackage #:meetup-test
  (:use :common-lisp :lisp-unit))

(load "meetup")

(in-package :meetup-test)

(define-test monteeth-of-may-2013
  (assert-equal '(2013 5 13) (meetup:monteenth 5 2013)))
(define-test monteenth-of-august-2013
  (assert-equal '(2013 8 19) (meetup:monteenth 8 2013)))
(define-test monteenth-of-september-2013
  (assert-equal '(2013 9 16) (meetup:monteenth 9 2013)))

(define-test tuesteenth-of-march-2013
  (assert-equal '(2013 3 19) (meetup:tuesteenth 3 2013)))
(define-test tuesteenth-of-april-2013
  (assert-equal '(2013 4 16) (meetup:tuesteenth 4 2013)))
(define-test tuesteenth-of-august-2013
  (assert-equal '(2013 8 13) (meetup:tuesteenth 8 2013)))

(define-test wednesteenth-of-january-2013
  (assert-equal '(2013 1 16) (meetup:wednesteenth 1 2013)))
(define-test wednesteenth-of-february-2013
  (assert-equal '(2013 2 13) (meetup:wednesteenth 2 2013)))
(define-test wednesteenth-of-june-2013
  (assert-equal '(2013 6 19) (meetup:wednesteenth 6 2013)))

(define-test thursteenth-of-may-2013
  (assert-equal '(2013 5 16) (meetup:thursteenth 5 2013)))
(define-test thursteenth-of-june-2013
  (assert-equal '(2013 6 13) (meetup:thursteenth 6 2013)))
(define-test thursteenth-of-september-2013
  (assert-equal '(2013 9 19) (meetup:thursteenth 9 2013)))

(define-test friteenth-of-april-2013
  (assert-equal '(2013 4 19) (meetup:friteenth 4 2013)))
(define-test friteenth-of-august-2013
  (assert-equal '(2013 8 16) (meetup:friteenth 8 2013)))
(define-test friteenth-of-september-2013
  (assert-equal '(2013 9 13) (meetup:friteenth 9 2013)))

(define-test saturteenth-of-february-2013
  (assert-equal '(2013 2 16) (meetup:saturteenth 2 2013)))
(define-test saturteenth-of-april-2013
  (assert-equal '(2013 4 13) (meetup:saturteenth 4 2013)))
(define-test saturteenth-of-october-2013
  (assert-equal '(2013 10 19) (meetup:saturteenth 10 2013)))

(define-test sunteenth-of-may-2013
  (assert-equal '(2013 5 19) (meetup:sunteenth 5 2013)))
(define-test sunteenth-of-june-2013
  (assert-equal '(2013 6 16) (meetup:sunteenth 6 2013)))
(define-test sunteenth-of-october-2013
  (assert-equal '(2013 10 13) (meetup:sunteenth 10 2013)))

(define-test first-monday-of-march-2013
  (assert-equal '(2013 3 4) (meetup:first-monday 3 2013)))
(define-test first-monday-of-april-2013
  (assert-equal '(2013 4 1) (meetup:first-monday 4 2013)))

(define-test first-tuesday-of-may-2013
  (assert-equal '(2013 5 7) (meetup:first-tuesday 5 2013)))
(define-test first-tuesday-of-june-2013
  (assert-equal '(2013 6 4) (meetup:first-tuesday 6 2013)))

(define-test first-wednesday-of-july-2013
  (assert-equal '(2013 7 3) (meetup:first-wednesday 7 2013)))
(define-test first-wednesday-of-august-2013
  (assert-equal '(2013 8 7) (meetup:first-wednesday 8 2013)))

(define-test first-thursday-of-september-2013
  (assert-equal '(2013 9 5) (meetup:first-thursday 9 2013)))
(define-test first-thursday-of-october-2013
  (assert-equal '(2013 10 3) (meetup:first-thursday 10 2013)))

(define-test first-friday-of-november-2013
  (assert-equal '(2013 11 1) (meetup:first-friday 11 2013)))
(define-test first-friday-of-december-2013
  (assert-equal '(2013 12 6) (meetup:first-friday 12 2013)))

(define-test first-saturday-of-january-2013
  (assert-equal '(2013 1 5) (meetup:first-saturday 1 2013)))
(define-test first-saturday-of-january-2013
  (assert-equal '(2013 2 2) (meetup:first-saturday 2 2013)))

(define-test first-sunday-of-march-2013
  (assert-equal '(2013 3 3) (meetup:first-sunday 3 2013)))
(define-test first-sunday-of-april-2013
  (assert-equal '(2013 4 7) (meetup:first-sunday 4 2013)))

(define-test second-monday-of-march-2013
  (assert-equal '(2013 3 11) (meetup:second-monday 3 2013)))
(define-test second-monday-of-april-2013
  (assert-equal '(2013 4 8) (meetup:second-monday 4 2013)))

(define-test second-tuesday-of-may-2013
  (assert-equal '(2013 5 14) (meetup:second-tuesday 5 2013)))
(define-test second-tuesday-of-june-2013
  (assert-equal '(2013 6 11) (meetup:second-tuesday 6 2013)))

(define-test second-wednesday-of-july-2013
  (assert-equal '(2013 7 10) (meetup:second-wednesday 7 2013)))
(define-test second-wednesday-of-august-2013
  (assert-equal '(2013 8 14) (meetup:second-wednesday 8 2013)))

(define-test second-thursday-of-september-2013
  (assert-equal '(2013 9 12) (meetup:second-thursday 9 2013)))
(define-test second-thursday-of-october-2013
  (assert-equal '(2013 10 10) (meetup:second-thursday 10 2013)))

(define-test second-friday-of-november-2013
  (assert-equal '(2013 11 8) (meetup:second-friday 11 2013)))
(define-test second-friday-of-december-2013
  (assert-equal '(2013 12 13) (meetup:second-friday 12 2013)))

(define-test second-saturday-of-january-2013
  (assert-equal '(2013 1 12) (meetup:second-saturday 1 2013)))
(define-test second-saturday-of-february-2013
  (assert-equal '(2013 2 9) (meetup:second-saturday 2 2013)))

(define-test second-sunday-of-march-2013
  (assert-equal '(2013 3 10) (meetup:second-sunday 3 2013)))
(define-test second-sunday-of-april-2013
  (assert-equal '(2013 4 14) (meetup:second-sunday 4 2013)))

(define-test third-monday-of-march-2013
  (assert-equal '(2013 3 18) (meetup:third-monday 3 2013)))
(define-test third-monday-of-april-2013
  (assert-equal '(2013 4 15) (meetup:third-monday 4 2013)))

(define-test third-tuesday-of-may-2013
  (assert-equal '(2013 5 21) (meetup:third-tuesday 5 2013)))
(define-test third-tuesday-of-june-2013
  (assert-equal '(2013 6 18) (meetup:third-tuesday 6 2013)))

(define-test third-wednesday-of-july-2013
  (assert-equal '(2013 7 17) (meetup:third-wednesday 7 2013)))
(define-test third-wednesday-of-august-2013
  (assert-equal '(2013 8 21) (meetup:third-wednesday 8 2013)))

(define-test third-thursday-of-september-2013
  (assert-equal '(2013 9 19) (meetup:third-thursday 9 2013)))
(define-test third-thursday-of-october-2013
  (assert-equal '(2013 10 17) (meetup:third-thursday 10 2013)))

(define-test third-friday-of-november-2013
  (assert-equal '(2013 11 15) (meetup:third-friday 11 2013)))
(define-test third-friday-of-december-2013
  (assert-equal '(2013 12 20) (meetup:third-friday 12 2013)))

(define-test third-saturday-of-january-2013
  (assert-equal '(2013 1 19) (meetup:third-saturday 1 2013)))
(define-test third-saturday-of-february-2013
  (assert-equal '(2013 2 16) (meetup:third-saturday 2 2013)))

(define-test third-sunday-of-march-2013
  (assert-equal '(2013 3 17) (meetup:third-sunday 3 2013)))
(define-test third-sunday-of-april-2013
  (assert-equal '(2013 4 21) (meetup:third-sunday 4 2013)))

(define-test fourth-monday-of-march-2013
  (assert-equal '(2013 3 25) (meetup:fourth-monday 3 2013)))
(define-test fourth-monday-of-april-2013
  (assert-equal '(2013 4 22) (meetup:fourth-monday 4 2013)))

(define-test fourth-tuesday-of-may-2013
  (assert-equal '(2013 5 28) (meetup:fourth-tuesday 5 2013)))
(define-test fourth-tuesday-of-june-2013
  (assert-equal '(2013 6 25) (meetup:fourth-tuesday 6 2013)))

(define-test fourth-wednesday-of-july-2013
  (assert-equal '(2013 7 24) (meetup:fourth-wednesday 7 2013)))
(define-test fourth-wednesday-of-august-2013
  (assert-equal '(2013 8 28) (meetup:fourth-wednesday 8 2013)))

(define-test fourth-thursday-of-september-2013
  (assert-equal '(2013 9 26) (meetup:fourth-thursday 9 2013)))
(define-test fourth-thursday-of-october-2013
  (assert-equal '(2013 10 24) (meetup:fourth-thursday 10 2013)))

(define-test fourth-friday-of-november-2013
  (assert-equal '(2013 11 22) (meetup:fourth-friday 11 2013)))
(define-test fourth-friday-of-december-2013
  (assert-equal '(2013 12 27) (meetup:fourth-friday 12 2013)))

(define-test fourth-saturday-of-january-2013
  (assert-equal '(2013 1 26) (meetup:fourth-saturday 1 2013)))
(define-test fourth-saturday-of-february-2013
  (assert-equal '(2013 2 23) (meetup:fourth-saturday 2 2013)))

(define-test fourth-sunday-of-march-2013
  (assert-equal '(2013 3 24) (meetup:fourth-sunday 3 2013)))
(define-test fourth-sunday-of-april-2013
  (assert-equal '(2013 4 28) (meetup:fourth-sunday 4 2013)))

(define-test last-monday-of-march-2013
  (assert-equal '(2013 3 25) (meetup:last-monday 3 2013)))
(define-test last-monday-of-april-2013
  (assert-equal '(2013 4 29) (meetup:last-monday 4 2013)))

(define-test last-tuesday-of-may-2013
  (assert-equal '(2013 5 28) (meetup:last-tuesday 5 2013)))
(define-test last-tuesday-of-june-2013
  (assert-equal '(2013 6 25) (meetup:last-tuesday 6 2013)))

(define-test last-wednesday-of-july-2013
  (assert-equal '(2013 7 31) (meetup:last-wednesday 7 2013)))
(define-test last-wednesday-of-august-2013
  (assert-equal '(2013 8 28) (meetup:last-wednesday 8 2013)))

(define-test last-thursday-of-september-2013
  (assert-equal '(2013 9 26) (meetup:last-thursday 9 2013)))
(define-test last-thursday-of-october-2013
  (assert-equal '(2013 10 31) (meetup:last-thursday 10 2013)))

(define-test last-friday-of-november-2013
  (assert-equal '(2013 11 29) (meetup:last-friday 11 2013)))
(define-test last-friday-of-december-2013
  (assert-equal '(2013 12 27) (meetup:last-friday 12 2013)))

(define-test last-saturday-of-january-2013
  (assert-equal '(2013 1 26) (meetup:last-saturday 1 2013)))
(define-test last-saturday-of-february-2013
  (assert-equal '(2013 2 23) (meetup:last-saturday 2 2013)))

(define-test last-sunday-of-march-2013
  (assert-equal '(2013 3 31) (meetup:last-sunday 3 2013)))
(define-test last-sunday-of-april-2013
  (assert-equal '(2013 4 28) (meetup:last-sunday 4 2013)))

(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all :meetup-test))
