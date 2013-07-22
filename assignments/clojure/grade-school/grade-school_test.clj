(ns grade-school.test (:use clojure.test))
(load-file "school.clj")

(def db {})

(deftest add-student
  (is (= {2 ["Aimee"]} (school/add db "Aimee" 2))))

(deftest add-more-students-in-same-class
  (is (= {2 ["James", "Blair", "Paul"]}
         (-> db
             (school/add "James" 2)
             (school/add "Blair" 2)
             (school/add "Paul" 2)))))

(deftest add-students-to-different-grades
  (is (= {3 ["Chelsea"] 7 ["Logan"]}
         (-> db
             (school/add "Chelsea" 3)
             (school/add "Logan" 7)))))

(deftest get-students-in-a-grade
  (is (= ["Franklin", "Bradley"]
         (-> db
             (school/add "Franklin" 5)
             (school/add "Bradley" 5)
             (school/add "Jeff" 1)
             (school/grade 5)))))

(deftest get-students-in-a-non-existant-grade
  (is (= [] (school/grade db 1))))

(deftest sorted-school
  (is (= { 3 ["Kyle"]
           4 ["Christopher" "Jennifer"]
           6 ["Kareem"] }
         (-> db
             (school/add "Jennifer" 4)
             (school/add "Kareem" 6)
             (school/add "Christopher" 4)
             (school/add "Kyle" 3)
             (school/sorted)))))

(run-tests)

