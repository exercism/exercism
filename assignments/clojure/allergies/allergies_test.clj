(ns allergies.test (:require [clojure.test :refer :all]))
(load-file "allergies.clj")

(deftest no-allergies-at-all
  (is (= [] (allergies/list 0))))

(deftest allergic-to-just-eggs
  (is (= ["eggs"] (allergies/list 1))))

(deftest allergic-to-just-peanuts
  (is (= ["peanuts"] (allergies/list 2))))

(deftest allergic-to-just-strawberries
  (is (= ["strawberries"] (allergies/list 8))))

(deftest allergic-to-eggs-and-peanuts
  (is (= ["eggs", "peanuts"] (allergies/list 3))))

(deftest allergic-to-more-than-eggs-but-not-peanuts
  (is (= ["eggs", "shellfish"] (allergies/list 5))))

(deftest allergic-to-lots-of-stuff
  (is (= ["strawberries", "tomatoes", "chocolate", "pollen", "cats"] (allergies/list 248))))

(deftest allergic-to-everything
  (is (= ["eggs", "peanuts", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats"] (allergies/list 255))))

(deftest no-allergies-means-not-allergic
  (is (not (allergies/allergic_to? 0 "peanuts")))
  (is (not (allergies/allergic_to? 0 "cats")))
  (is (not (allergies/allergic_to? 0 "strawberries"))))

(deftest is-allergic-to-eggs
  (is (allergies/allergic_to? 1 "eggs")))

(deftest allergic-to-eggs-in-addition-to-other-stuff
  (is (allergies/allergic_to? 5 "eggs")))

(deftest ignore-non-allergen-score-parts
  (is (= ["eggs", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats"] (allergies/list 509))))

(run-tests)
