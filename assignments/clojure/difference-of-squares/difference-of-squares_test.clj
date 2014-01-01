(ns difference_of_squares.test (:require [clojure.test :refer :all]))
(load-file "squares.clj")

(deftest square-of-sums-to-5
  (is (= 225 (square-of-sums 5))))
(deftest sum-of-squares-to-5
  (is (= 55 (sum-of-squares 5))))
(deftest difference-of-sums-to-5
  (is (= 170 (difference 5))))
(deftest square-of-sums-to-10
  (is (= 3025 (square-of-sums 10))))
(deftest sum-of-squares-to-10
  (is (= 385 (sum-of-squares 10))))
(deftest difference-of-sums-to-10
  (is (= 2640 (difference 10))))
(deftest square-of-sums-to-100
  (is (= 25502500 (square-of-sums 100))))
(deftest sum-of-squares-to-100
  (is (= 338350 (sum-of-squares 100))))
(deftest difference-of-sums-to-100 
  (is (= 25164150 (difference 100))))

(run-tests)

