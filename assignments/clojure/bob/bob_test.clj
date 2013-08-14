(ns bob.test (:use clojure.test))
(load-file "bob.clj")

(deftest responds-to-something
  (is (= "Whatever." (bob/response-for "Tom-ay-to, tom-aaaah-to."))))

(deftest responds-to-shouts
  (is (= "Woah, chill out!" (bob/response-for "WATCH OUT!"))))

(deftest responds-to-questions
  (is (= "Sure." (bob/response-for "Does this cryogenic chamber make me look fat?"))))

(deftest responds-to-forceful-talking
  (is (= "Whatever." (bob/response-for "Let's go make out behind the gym!"))))

(deftest responds-to-acronyms
  (is (= "Whatever." (bob/response-for "It's OK if you don't want to go to the DMV."))))

(deftest responds-to-forceful-questions
  (is (= "Woah, chill out!" (bob/response-for "WHAT THE HELL WERE YOU THINKING?"))))

(deftest responds-to-shouting-with-special-characters
  (is (= "Woah, chill out!" (bob/response-for "ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!"))))

(deftest responds-to-shouting-numbers
  (is (= "Woah, chill out!" (bob/response-for "1, 2, 3 GO!"))))

(deftest responds-to-shouting-with-no-exclamation-mark
  (is (= "Woah, chill out!" (bob/response-for "I HATE YOU"))))

(deftest responds-to-statement-containing-question-mark
  (is (= "Whatever." (bob/response-for "Ending with ? means a question."))))

(deftest responds-to-silence
  (is (= "Fine. Be that way." (bob/response-for ""))))

(run-tests)
