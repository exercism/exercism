(ns roman.test (:require [clojure.test :refer :all]))
(load-file "roman.clj")

(deftest one
  (is (= "I" (roman/numerals 1))))

(deftest two
  (is (= "II" (roman/numerals 2))))

(deftest three
  (is (= "III" (roman/numerals 3))))

(deftest four
  (is (= "IV" (roman/numerals 4))))

(deftest five
  (is (= "V" (roman/numerals 5))))

(deftest six
  (is (= "VI" (roman/numerals 6))))

(deftest nine
  (is (= "IX" (roman/numerals 9))))

(deftest twenty-seven
  (is (= "XXVII" (roman/numerals 27))))

(deftest forty-eight
  (is (= "XLVIII" (roman/numerals 48))))

(deftest fifty-nine
  (is (= "LIX" (roman/numerals 59))))

(deftest ninety-three
  (is (= "XCIII" (roman/numerals 93))))

(deftest one-hundred-forty-one
  (is (= "CXLI" (roman/numerals 141))))

(deftest one-hundred-sixty-three
  (is (= "CLXIII" (roman/numerals 163))))

(deftest four-hundred-two
  (is (= "CDII" (roman/numerals 402))))

(deftest five-hundred-seventy-five
  (is (= "DLXXV" (roman/numerals 575))))

(deftest nine-hundred-eleven
  (is (= "CMXI" (roman/numerals 911))))

(deftest one-thousand-twenty-four
  (is (= "MXXIV" (roman/numerals 1024))))

(deftest three-thousand
  (is (= "MMM" (roman/numerals 3000))))

(run-tests)
