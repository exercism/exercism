(def directions [:north :east :south :west])

(defn robot [coordinates bearing]
  {:coordinates coordinates :bearing bearing})

(defn turn [bearing direction-list]
  (let [dir-stream (drop-while #(not (= bearing %1)) (cycle direction-list))]
    (nth dir-stream 1)))

(defn turn-right [bearing]
  (turn bearing directions))

(defn turn-left [bearing]
  (turn bearing (reverse directions)))

(defn advance [coordinates bearing]
  (let [x (:x coordinates)
        y (:y coordinates)]
    (cond
      (= :north bearing) {:x x :y (inc y)}
      (= :south bearing) {:x x :y (dec y)}
      (= :east  bearing) {:x (inc x) :y y}
      (= :west  bearing) {:x (dec x) :y y})))

(defn simulate [instructions current-state]
  (loop [instructions  instructions
         current-state current-state]
    (let [instruction (first instructions)
          remainder   (rest  instructions)
          coordinates (:coordinates current-state)
          bearing     (:bearing current-state)
          next-state  (cond
                           (= \L instruction)
                             (robot coordinates (turn-left bearing))
                           (= \R instruction)
                             (robot coordinates (turn-right bearing))
                           :else
                             (robot (advance coordinates bearing) bearing))]
      (if (seq remainder)
        (recur remainder next-state)
        next-state))))

