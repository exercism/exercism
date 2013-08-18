(ns raindrops.test (:require [clojure.test :refer :all]))
(load-file "raindrops.clj")

(deftest one
  (is (= "1" (drops/convert 1))))

(deftest three
  (is (= "Pling" (drops/convert 3))))

(deftest five
  (is (= "Plang" (drops/convert 5))))

(deftest seven
  (is (= "Plong" (drops/convert 7))))

(deftest six
  (is (= "Pling" (drops/convert 6))))

(deftest nine
  (is (= "Pling" (drops/convert 9))))

(deftest ten
  (is (= "Plang" (drops/convert 10))))

(deftest fourteen
  (is (= "Plong" (drops/convert 14))))

(deftest fifteen
  (is (= "PlingPlang" (drops/convert 15))))

(deftest twenty-one
  (is (= "PlingPlong" (drops/convert 21))))

(deftest twenty-five
  (is (= "Plang" (drops/convert 25))))

(deftest thirty-five
  (is (= "PlangPlong" (drops/convert 35))))

(deftest forty-nine
  (is (= "Plong" (drops/convert 49))))

(deftest fifty-two
  (is (= "52" (drops/convert 52))))

(deftest one-hundred-five
  (is (= "PlingPlangPlong" (drops/convert 105))))

(deftest twelve-thousand-one-hundred-twenty-one
  (is (= "12121" (drops/convert 12121))))

(run-tests)
