(ns kindergarten.test (:require [clojure.test :refer :all]))
(load-file "garden.clj")

(deftest garden-test
  (is (= [:radishes :clover :grass :grass] (:alice (garden "RC\nGG"))))
  (is (= [:violets :clover :radishes :clover] (:alice (garden "VC\nRC")))))

(def small-garden (garden "VVCG\nVVRC"))
(deftest small-garden-test
  (is (= [:clover :grass :radishes :clover] (:bob small-garden))))

(def medium-garden (garden "VVCCGG\nVVCCGG"))
(deftest medium-garden-test
  (is (= [:clover :clover :clover :clover] (:bob medium-garden)))
  (is (= [:grass :grass :grass :grass] (:charlie medium-garden))))

(def full-garden (garden "VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV"))
(deftest full-garden-test
  (is (= [:violets  :radishes :violets  :radishes] (:alice   full-garden)))
  (is (= [:clover   :grass    :clover   :clover]   (:bob     full-garden)))
  (is (= [:violets  :violets  :clover   :grass]    (:charlie full-garden)))
  (is (= [:radishes :violets  :clover   :radishes] (:david   full-garden)))
  (is (= [:clover   :grass    :radishes :grass]    (:eve     full-garden)))
  (is (= [:grass    :clover   :violets  :clover]   (:fred    full-garden)))
  (is (= [:clover   :grass    :grass    :clover]   (:ginny   full-garden)))
  (is (= [:violets  :radishes :radishes :violets]  (:harriet full-garden)))
  (is (= [:grass    :clover   :violets  :clover]   (:ileana  full-garden)))
  (is (= [:violets  :clover   :violets  :grass]    (:joseph  full-garden)))
  (is (= [:grass    :clover   :clover   :grass]    (:kincaid full-garden)))
  (is (= [:grass    :violets  :clover   :violets]  (:larry   full-garden))))

(def surprise-garden (garden "VCRRGVRG\nRVGCCGCV" ["Samantha" "Patricia" "Xander" "Roger"]))
(deftest surprise-garden-test
  (is (= [:violets  :clover   :radishes :violets] (:patricia surprise-garden)))
  (is (= [:radishes :radishes :grass    :clover]  (:roger    surprise-garden)))
  (is (= [:grass    :violets  :clover   :grass]   (:samantha surprise-garden)))
  (is (= [:radishes :grass    :clover   :violets] (:xander   surprise-garden))))

(run-tests)


