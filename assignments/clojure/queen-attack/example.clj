(require '[clojure.string :as str])
(require '[clojure.set    :as set])

(defn board-string [queens]
  (let [piece-at (set/map-invert queens)]
    (str/join "\n"
              (map #(str/join " " %1)
                   (conj (vec (partition 8
                              (for [x (range 8)
                                    y (range 8)]
                                (.toUpperCase (name (or (piece-at [x y])
                                    "O")))
                                  )))
                         nil)))))

(defn same-row [queens]
  (= (first (:w queens))
     (first (:b queens))))

(defn same-col [queens]
  (= (last (:w queens))
     (last (:b queens))))

(defn diagonal [queens]
  (let [xdiff (- (first (:w queens)) (first (:b queens)))
        ydiff (- (last  (:w queens)) (last  (:b queens)))]
    (= xdiff ydiff)))

(defn can-attack [queens]
  (or (same-row queens)
      (same-col queens)
      (diagonal queens)))
