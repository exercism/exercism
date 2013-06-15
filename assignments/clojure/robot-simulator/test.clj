(load-file "robot.clj")

(def robbie (robot {:x -2 :y 1} :east))
(assert (= :east (:bearing robbie)))
(assert (= {:x -2 :y 1} (:coordinates robbie)))

(assert (= :north (turn-right :west)))
(assert (= :west  (turn-left :north)))

(assert (= :west (:bearing (simulate "RLAALAL" robbie))))
(assert (= {:x 0 :y 2} (:coordinates (simulate "RLAALAL" robbie))))

(def clutz  (robot {:x 0 :y  0} :north))
(def sphero (robot {:x 2 :y -7} :east))
(def roomba (robot {:x 8 :y  4} :south))

(let [clutz (simulate "LAAARALA" clutz)]
  (assert (= :west (:bearing clutz)))
  (assert (= {:x -4 :y 1} (:coordinates clutz))))

(let [sphero (simulate "RRAAAAALA" sphero)]
  (assert (= :south (:bearing sphero)))
  (assert (= {:x -3 :y -8} (:coordinates sphero))))

(let [roomba (simulate "LAAARRRALLLL" roomba)]
  (assert (= :north (:bearing roomba)))
  (assert (= {:x 11 :y 5} (:coordinates roomba))))
