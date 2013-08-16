(ns prime-factors)

(defn- least-prime-divisor
  [number]
  (or (first
        (filter #(zero? (rem number %1))
                 (range 2 (inc (/ number 2)))))
      number))

(defn of [number]
  (if
    (< number 2) []
    (let [divisor (least-prime-divisor number)]
      (into [divisor] (of (/ number divisor))))))
