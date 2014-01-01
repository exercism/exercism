(ns accumulate.test (:require [clojure.test :refer :all]))
(load-file "accumulate.clj")

(defn- square [n] (* n n))
(defn- to-s [xs] (apply str xs))

(deftest empty-accumulation
  (is (= [] (accum/accumulate square []))))

(deftest accumulate-squares
  (is (= [1 4 9] (accum/accumulate square [1 2 3]))))
   
(deftest accumulate-upcases
  (is (= ["HELLO", "WORLD"] 
         (map to-s (accum/accumulate clojure.string/upper-case ["hello" "world"])))))

(deftest accumulate-reversed-strings
  (is (= ["eht" "kciuq" "nworb" "xof" "cte"]
         (map to-s (accum/accumulate reverse ["the" "quick" "brown" "fox" "etc"])))))

(deftest accumulate-recursively
  (is (= [["a1" "a2" "a3"] ["b1" "b2" "b3"] ["c1" "c2" "c3"]]
         (accum/accumulate #(accum/accumulate (fn [n] (str % n)) [1 2 3]) "abc"))))
 
(run-tests)

