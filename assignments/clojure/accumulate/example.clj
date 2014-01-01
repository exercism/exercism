(ns accum)

(defn accumulate [f xs]
  (loop [xs xs
         accum []]
    (if
      (empty? xs) accum
      (recur (rest xs) (conj accum (f (first xs)))))))

