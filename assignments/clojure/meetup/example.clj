(ns meetup
  (:import (java.util Calendar)))

(def day-offsets {:sunday    1
                  :monday    2
                  :tuesday   3
                  :wednesday 4
                  :thursday  5
                  :friday    6
                  :saturday  7})

(def ordinals {:first  1
               :second 2
               :third  3
               :fourth 4})

(defn- abs [n]
  (cond
    (neg? n) (* -1 n)
    :else    n))

(defn- ^Calendar to-date
  [year month day]
  (let [cal (Calendar/getInstance)]
    (.set cal Calendar/YEAR year)
    (.set cal Calendar/MONTH (dec month))
    (.set cal Calendar/DATE day)
    (.set cal Calendar/HOUR_OF_DAY 0)
    (.set cal Calendar/MINUTE 0)
    (.set cal Calendar/SECOND 0)
    (.set cal Calendar/MILLISECOND 0)
    cal))

(defn- date-parts
  [date]
  [(.get date Calendar/YEAR)
   (inc (.get date Calendar/MONTH))
   (.get date Calendar/DATE)])

(defn- days-to-move
  [weekday offset-and-direction]
  (let [offset    (abs offset-and-direction)
        direction (/ offset-and-direction offset)]
    (* (mod (* -1 direction (- weekday offset)) 7) direction)))

(defn- offset-date
  [year month day offset]
  (let [date    (to-date year month day)
        weekday (.get date Calendar/DAY_OF_WEEK)]
    (.roll date Calendar/DATE (days-to-move weekday offset))
    date))

(defn- last-day-of-month
  [year month]
  (let [date (to-date year month 1)]
    (.getActualMaximum date Calendar/DAY_OF_MONTH)))

; generate the "*teenth" functions
(doseq [[day-name offset] day-offsets]
  (let [fname (symbol
                (clojure.string/replace
                  (name day-name) #"day" "teenth"))]
    (intern *ns* fname
            (fn [month year]
              (date-parts (offset-date year month 13 offset))))))

; generate the ordinal day functions
(doseq [[ordinal week-number] ordinals]
  (doseq [[day-name offset] day-offsets]
    (let [fname (symbol (str (name ordinal) "-" (name day-name)))
          day-of-month (inc (* (dec week-number) 7))]
      (intern *ns* fname
              (fn [month year]
                (date-parts (offset-date year month day-of-month offset)))))))

; generate the "last*" functions
(doseq [[day-name offset] day-offsets]
  (let [fname (symbol (str "last-" (name day-name)))]
    (intern *ns* fname
            (fn [month year]
              (let [last-day (last-day-of-month year month)]
                (date-parts (offset-date year month last-day (* -1 offset))))))))
