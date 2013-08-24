(ns robot-name.test (:require [clojure.test :refer :all]))
(load-file "robot.clj")

(def robbie (robot))
(def clutz  (robot))

(deftest name-matches-expected-pattern
  (is (re-find (re-matcher #"[A-Z]{2}\d{3}" (robot-name robbie)))))

(deftest name-is-persistent
  (is (= (robot-name robbie) (robot-name robbie))))

(deftest different-robots-have-different-names
  (is (not (= (robot-name clutz) (robot-name robbie)))))

(def original-name (robot-name robbie))
(reset-name robbie)

(deftest new-name-matches-expected-pattern
  (is (re-find (re-matcher #"[A-Z]{2}\d{3}" (robot-name robbie)))))

(deftest new-name-is-persistent
  (is (= (robot-name robbie) (robot-name robbie))))

(deftest new-name-is-different-than-old-name
  (is (not (= original-name (robot-name robbie)))))

(run-tests)
