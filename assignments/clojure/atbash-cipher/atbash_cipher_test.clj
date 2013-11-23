(ns atbash-cipher.test (:use clojure.test))
(load-file "atbash.clj")

(deftest encode-no
  (is (= "ml" (atbash/encode "no"))))

(deftest encode-yes
  (is (= "bvh" (atbash/encode "yes"))))

(deftest encode-OMG
  (is (= "lnt" (atbash/encode "OMG"))))

(deftest encode-O-M-G
  (is (= "lnt" (atbash/encode "O M G"))))

(deftest encode-long-word
  (is (= "nrmwy oldrm tob" (atbash/encode "mindblowingly"))))

(deftest encode-numbers
  (is (= "gvhgr mt123 gvhgr mt" (atbash/encode "Testing, 1 2 3, testing."))))

(deftest encode-sentence
  (is (= "gifgs rhurx grlm" (atbash/encode "Truth is fiction."))))

(deftest encode-all-the-things
  (let [plaintext "The quick brown fox jumps over the lazy dog."
        cipher "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt"]
    (is (= cipher (atbash/encode plaintext)))))

(run-tests)
