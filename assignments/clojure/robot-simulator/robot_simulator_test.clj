(ns robot_simulator.test (:require [clojure.test :refer :all]))
(load-file "robot.clj")

(def robbie (robot {:x -2 :y 1} :east))
(deftest can-get-vals
  (is (= :east (:bearing robbie)))
  (is (= {:x -2 :y 1} (:coordinates robbie))))

(deftest can-turn
  (is (= :north (turn-right :west)))
  (is (= :west  (turn-left :north))))

(deftest can-simulate
  (is (= :west (:bearing (simulate "RLAALAL" robbie))))
  (is (= {:x 0 :y 2} (:coordinates (simulate "RLAALAL" robbie)))))

(def clutz  (robot {:x 0 :y  0} :north))
(def sphero (robot {:x 2 :y -7} :east))
(def roomba (robot {:x 8 :y  4} :south))

(deftest simulate-clutz
  (let [clutz (simulate "LAAARALA" clutz)]
    (is (= :west (:bearing clutz)))
    (is (= {:x -4 :y 1} (:coordinates clutz)))))

(deftest simulate-sphero
  (let [sphero (simulate "RRAAAAALA" sphero)]
    (is (= :south (:bearing sphero)))
    (is (= {:x -3 :y -8} (:coordinates sphero)))))

(deftest simulate-roomba
  (let [roomba (simulate "LAAARRRALLLL" roomba)]
    (is (= :north (:bearing roomba)))
    (is (= {:x 11 :y 5} (:coordinates roomba)))))

(run-tests)

