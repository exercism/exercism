(ns etl.test (:require [clojure.test :refer :all]))
(load-file "etl.clj")


(deftest transform-one-value
  (is (= {"world" 1}
         (etl/transform {1 ["WORLD"]}))))

(deftest transform-more-values
  (is (= {"world" 1 "gschoolers" 1}
         (etl/transform {1 ["WORLD" "GSCHOOLERS"]}))))

(deftest more-keys
  (is (= {"apple" 1 "artichoke" 1 "boat" 2 "ballerina" 2}
         (etl/transform {1 ["APPLE" "ARTICHOKE"] 2 ["BOAT" "BALLERINA"] }))))

(deftest full-dataset
  (is (= { "a"  1 "b"  3 "c" 3 "d" 2 "e" 1
           "f"  4 "g"  2 "h" 4 "i" 1 "j" 8
           "k"  5 "l"  1 "m" 3 "n" 1 "o" 1
           "p"  3 "q" 10 "r" 1 "s" 1 "t" 1
           "u"  1 "v"  4 "w" 4 "x" 8 "y" 4
           "z" 10 }
         (etl/transform {
             1 (subvec (clojure.string/split "AEIOULNRST" #"") 1)
             2 (subvec (clojure.string/split "DG" #"") 1)
             3 (subvec (clojure.string/split "BCMP" #"") 1)
             4 (subvec (clojure.string/split "FHVWY" #"") 1)
             5 (subvec (clojure.string/split "K" #"") 1)
             8 (subvec (clojure.string/split "JX" #"") 1)
            10 (subvec (clojure.string/split "QZ" #"") 1)
         }))))

(run-tests)
