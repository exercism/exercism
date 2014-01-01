
(defn- char-between [start end c]
  (let [ascii (int c)]
    (and (>= ascii (int start)) (<= ascii (int end)))))

(def is-digit (partial char-between \0 \9))
(def is-a-to-f (partial char-between \a \f))

(defn- is-hex-digit [c]
    (or (is-digit c) (is-a-to-f c)))

(defn- digit-to-int [c]
  (cond 
    (is-digit c) (- (int c) (int \0))
    (is-a-to-f c) (+ (- (int c) (int \a)) 10)
    :else (throw (Exception. "Character is not a hex digit"))))

(defn hex-to-int [digits]
  (if 
    (some (complement is-hex-digit) digits) 0
    (reduce #(+ (digit-to-int %2) (* %1 16)) 0 digits)))

