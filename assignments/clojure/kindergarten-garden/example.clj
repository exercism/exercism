(def default-students ["Alice" "Bob" "Charlie" "David" "Eve" "Fred" "Ginny"
                       "Harriet" "Ileana" "Joseph" "Kincaid" "Larry"])

(def seeds { "G" :grass "C" :clover "R" :radishes "V" :violets })

(defn row-to-seeds [row-string]
  (map seeds (rest (clojure.string/split row-string #""))))

(defn garden-to-rows [garden]
  (clojure.string/split-lines garden))

(defn garden
  ([string]
    (garden string default-students))
  ([string students]
    (let [students (map #(keyword (.toLowerCase %1)) (sort students))
          [front back] (map #(partition 2 %1)
                             (map row-to-seeds (garden-to-rows string)))]
      (zipmap students (map vec
                          (map flatten
                             (partition 2 (interleave front back))))))))
