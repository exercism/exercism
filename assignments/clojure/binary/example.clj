(ns binary)

(defn- pow [x n]
  (loop [x (bigint x) n (bigint n) r 1]
    (cond
      (= n 0) r
      (even? n) (recur (* x x) (/ n 2) r)
      :else (recur x (dec n) (* r x)))))

(defn- power [[exponent bit]]
  (if (= "1" bit)
      (pow 2 exponent)
      0))

(defn- bits [string]
  (->> string
       (re-seq #"[10]")
       reverse
       (map-indexed vector)))

(defn to-decimal [string]
  (->> string
       bits
       (map power)
       (apply +)))
