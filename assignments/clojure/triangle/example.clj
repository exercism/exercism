(defn invalid-sides [a b c]
  (let [[a b c] (sort [a b c])]
    (or (<= a 0)
        (>= c (+ a b)))))

(defn triangle [a b c]
  (let [unique-sides (partition-by identity (sort [a b c]))
        unique-side-count (count unique-sides)
        invalid (invalid-sides a b c)]
    (cond
      invalid                 :illogical
      (= 1 unique-side-count) :equilateral
      (= 2 unique-side-count) :isosceles
      :else                   :scalene)))
