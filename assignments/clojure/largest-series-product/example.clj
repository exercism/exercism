
(defn digits [ds] (map #(Character/digit % 10) ds))

(defn slices [n ds] 
  (partition n 1 (digits ds)))

(defn largest-product [size ds] 
  (if 
    (or (empty? ds) (> size (count ds))) 1
    (apply max (map #(apply * %) (slices size ds)))))

