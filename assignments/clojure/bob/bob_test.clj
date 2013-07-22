(ns bob.test (:use clojure.test))
(load-file "bob.clj")

(deftest responds-to-shouts
  (is (= "Woah, chill out!" (bob/response-for "SHOUTING"))))

(deftest responds-to-questions
  (is (= "Sure." (bob/response-for "A question?"))))

(deftest responds-to-statements
  (is (= "Whatever." (bob/response-for "A statement."))))

(deftest responds-to-silence
  (is (= "Fine, be that way." (bob/response-for ""))))

(run-tests)
