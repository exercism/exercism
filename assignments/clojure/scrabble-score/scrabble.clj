(require '[clojure.string :refer [split]])

(defn score-letter [letter]
  (let [ul (.toUpperCase letter)]
    (cond
      (some #{ul} (split "AEIOULNRST" #""))  1
      (some #{ul} (split "DG" #"")        )  2
      (some #{ul} (split "BCMP" #"")      )  3
      (some #{ul} (split "FHVWY" #"")     )  4
      (some #{ul} (split "K" #"")         )  5
      (some #{ul} (split "JX" #"")        )  8
      (some #{ul} (split "QZ" #"")        ) 10
    )))

(defn score-word [word]
  (reduce + (map score-letter (rest (split word #"")))))
