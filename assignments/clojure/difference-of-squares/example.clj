
(defn- sum [xs] (reduce + xs))

(defn sum-of-squares [n]
  (sum (map #(int (Math/pow % 2)) (range 0 (inc n)))))

(defn square-of-sums [n]
  (int (Math/pow (sum (range 0 (inc n))) 2)))

(defn difference [x]
  (- (square-of-sums x) (sum-of-squares x)))
