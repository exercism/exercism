(load-file "robot.clj")

(def robbie (robot))
(assert (re-find (re-matcher #"[A-Z]{2}\d{3}" (robot-name robbie))))
(assert (= (robot-name robbie) (robot-name robbie)))

(def original-name (robot-name robbie))
(reset-name robbie)
(assert (re-find (re-matcher #"[A-Z]{2}\d{3}" (robot-name robbie))))
(assert (= (robot-name robbie) (robot-name robbie)))
(assert (not (= original-name (robot-name robbie))))
