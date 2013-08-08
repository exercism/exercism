(ns grains)

(defn- pow [x n]
  (loop [x (bigint x) n (bigint n) r 1]
    (cond
      (= n 0) r
      (even? n) (recur (* x x) (/ n 2) r)
      :else (recur x (dec n) (* r x)))))

(defn square [number]
  (pow 2 (dec number)))

(def ^:private square-numbers (rest (range 65)))

(defn total []
  (apply + (map square square-numbers)))
