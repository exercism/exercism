(ns school)

(defn grade
  "show the roster for a specific grade"
  [db grade-level]
    (db grade-level []))

(defn add
  "add student to roster for grade"
  [db student grade-level]
    (let [roster (grade db grade-level)]
      (assoc db grade-level (conj roster student))))

(defn sorted
  "show the sorted roster for each grade"
  [db]
    (into {}
      (for [[grade-level roster] db]
        [grade-level (sort roster)])))
