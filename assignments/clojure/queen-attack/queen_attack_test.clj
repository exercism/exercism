(ns queens.test (:require [clojure.test :refer :all]))
(load-file "queens.clj")

(def empty-board
  (str "O O O O O O O O\n"
       "O O O O O O O O\n"
       "O O O O O O O O\n"
       "O O O O O O O O\n"
       "O O O O O O O O\n"
       "O O O O O O O O\n"
       "O O O O O O O O\n"
       "O O O O O O O O\n"))

(def board
  (str "O O O O O O O O\n"
       "O O O O O O O O\n"
       "O O O O W O O O\n"
       "O O O O O O O O\n"
       "O O O O O O O O\n"
       "O O O O O O O O\n"
       "O O O O O O B O\n"
       "O O O O O O O O\n"))

(deftest handles-empty-board
  (is (= empty-board (board-string {}))))
(deftest build-board
  (is (= board (board-string {:w [2 4] :b [6 6]}))))

(deftest finds-attack-positions
  (is (= false (can-attack {:w [2 3] :b [4 7]})))
  (is (= true  (can-attack {:w [2 4] :b [2 7]})))
  (is (= true  (can-attack {:w [5 4] :b [2 4]})))
  (is (= true  (can-attack {:w [1 1] :b [6 6]})))
  (is (= true  (can-attack {:w [0 6] :b [1 7]})))
  (is (= true  (can-attack {:w [4 1] :b [6 3]}))))

(run-tests)

