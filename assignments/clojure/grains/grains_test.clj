(ns grains.test (:require [clojure.test :refer :all]))
(load-file "grains.clj")

(deftest square-1
  (is (= 1 (grains/square 1))))

(deftest square-2
  (is (= 2 (grains/square 2))))

(deftest square-3
  (is (= 4 (grains/square 3))))

(deftest square-4
  (is (= 8 (grains/square 4))))

(deftest square-16
  (is (= 32768 (grains/square 16))))

(deftest square-32
  (is (= 2147483648 (grains/square 32))))

(deftest square-64
  (is (= 9223372036854775808 (grains/square 64))))

(deftest total-grains
  (is (= 18446744073709551615  (grains/total))))

(run-tests)
