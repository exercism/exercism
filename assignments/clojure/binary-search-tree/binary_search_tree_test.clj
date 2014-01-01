(ns bst.test (:require [clojure.test :refer :all]))
(load-file "bst.clj")

(deftest data-is-retained
  (is (= 4 (bst/value (bst/singleton 4)))))

(deftest inserting-less 
  (let [t (bst/insert 2 (bst/singleton 4))]
    (is (= 4 (bst/value t)))
    (is (= 2 (bst/value (bst/left t))))))

(deftest inserting-same
  (let [t (bst/insert 4 (bst/singleton 4))]
    (is (= 4 (bst/value t)))
    (is (= 4 (bst/value (bst/left t))))))

(deftest inserting-right
  (let [t (bst/insert 5 (bst/singleton 4))]
    (is (= 4 (bst/value t)))
    (is (= 5 (bst/value (bst/right t))))))

(deftest complex-tree
  (let [t (bst/from-list [4 2 6 1 3 7 5])]
    (is (= 4 (bst/value t)))
    (is (= 2 (bst/value (bst/left t))))
    (is (= 1 (bst/value (bst/left (bst/left t)))))
    (is (= 3 (bst/value (bst/right (bst/left t)))))
    (is (= 6 (bst/value (bst/right t))))
    (is (= 5 (bst/value (bst/left (bst/right t)))))
    (is (= 7 (bst/value (bst/right (bst/right t)))))))

(deftest iterating-one-element
  (is (= [4] (bst/to-list (bst/singleton 4)))))

(deftest iterating-over-smaller-element
  (is (= [2 4] (bst/to-list (bst/from-list [4 2])))))

(deftest iterating-over-larger-element
  (is (= [4 5] (bst/to-list (bst/from-list [4 5])))))

(deftest iterating-over-complex-tree 
  (is (= (range 1 8) (bst/to-list (bst/from-list [4 2 1 3 6 7 5])))))

(run-tests)

