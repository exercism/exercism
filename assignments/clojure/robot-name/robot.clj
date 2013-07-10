(defn robot []
  {:name (atom "")})

(def random (java.util.Random.))
(def letters (map char (range 65 91)))
(defn generate-name []
  (str (apply str (take 2 (shuffle letters)))
       (+ 100 (.nextInt random 899))))

(defn robot-name [robot]
  (let [n @(:name robot)]
    (if (= "" n)
        (swap! (:name robot) #(str %1 (generate-name)))
        n)))

(defn reset-name [robot]
  (swap! (:name robot) (fn [x] "")))
