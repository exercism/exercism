(ns gigasecond
  (require [clojure.string :refer [join]]))

(import java.text.SimpleDateFormat)
(import java.util.Date)

(def ^:private date-format "yyyy MM dd")

(defn- date-from-string [date-string]
  (.parse (SimpleDateFormat. date-format) date-string))

(defn- date [& parts]
  (-> (join " " parts)
      date-from-string
      .getTime))

(defn- date-parts [epoch]
  (let [date (new Date epoch)]
    [(+ 1900 (.getYear date))
     (+ 1 (.getMonth date))
     (.getDate date)]))

(defn from [year month day]
  (-> (date year month day)
      (+ 1000000000000)
      date-parts))
