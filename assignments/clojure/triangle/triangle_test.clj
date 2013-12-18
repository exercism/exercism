(ns triangle.test (:require [clojure.test :refer :all]))
(load-file "triangle.clj")

(deftest equilateral-1
  (is (= :equilateral (triangle 2 2 2))))
(deftest equilateral-2
  (is (= :equilateral (triangle 10 10 10))))
(deftest isoceles-1
  (is (= :isosceles (triangle 3 4 4))))
(deftest isoceles-2
  (is (= :isosceles (triangle 4 3 4))))
(deftest scalene
  (is (= :scalene (triangle 3 4 5))))
(deftest invalid-1
  (is (= :illogical (triangle 1 1 50))))
(deftest invalid-2
  (is (= :illogical (triangle 1 2 1))))

(run-tests)

