(ns binary.test (:require [clojure.test :refer :all]))
(load-file "binary.clj")

(deftest binary-1-is-decimal-1
  (is (= 1 (binary/to-decimal "1"))))

(deftest binary-10-is-decimal-2
  (is (= 2 (binary/to-decimal "10"))))

(deftest binary-11-is-decimal-3
  (is (= 3 (binary/to-decimal "11"))))

(deftest binary-100-is-decimal-4
  (is (= 4 (binary/to-decimal "100"))))

(deftest binary-1001-is-decimal-9
  (is (= 9 (binary/to-decimal "1001"))))

(deftest binary-11010-is-decimal-26
  (is (= 26 (binary/to-decimal "11010"))))

(deftest binary-10001101000-is-decimal-1128
  (is (= 1128 (binary/to-decimal "10001101000"))))

(deftest invalid-binary-is-decimal-0
  (is (= 0 (binary/to-decimal "carrot"))))

(run-tests)
