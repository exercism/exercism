(ns etl)
(require '[clojure.string :refer [lower-case]])

(defn transform [extract]
  (into {}
        (for [[score letters] extract
              letter          letters]
          [(lower-case letter) score])))
