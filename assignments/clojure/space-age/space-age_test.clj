(ns space-age.test (:require [clojure.test :refer :all]))
(load-file "space_age.clj")

(defn- rounds-to
  [expected actual]
  (is (= (Math/round (* 100 expected))
         (Math/round (* 100 actual)))))

(deftest age-in-earth-years
  (rounds-to 31.69 (space-age/on-earth 1000000000)))

(deftest age-in-mercury-years
  (let [seconds 2134835688]
    (rounds-to 67.65 (space-age/on-earth seconds))
    (rounds-to 280.88 (space-age/on-mercury seconds))))

(deftest age-in-venus-years
  (let [seconds 189839836]
    (rounds-to 6.02 (space-age/on-earth seconds))
    (rounds-to 9.78 (space-age/on-venus seconds))))

(deftest age-on-mars
  (let [seconds 2329871239]
    (rounds-to 73.83 (space-age/on-earth seconds))
    (rounds-to 39.25 (space-age/on-mars seconds))))

(deftest age-on-jupiter
  (let [seconds 901876382]
    (rounds-to 28.58 (space-age/on-earth seconds))
    (rounds-to 2.41 (space-age/on-jupiter seconds))))

(deftest age-on-saturn
  (let [seconds 3000000000]
    (rounds-to 95.06 (space-age/on-earth seconds))
    (rounds-to 3.23 (space-age/on-saturn seconds))))

(deftest age-on-uranus
  (let [seconds 3210123456]
    (rounds-to 101.72 (space-age/on-earth seconds))
    (rounds-to 1.21 (space-age/on-uranus seconds))))

(deftest age-on-neptune
  (let [seconds 8210123456]
    (rounds-to 260.16 (space-age/on-earth seconds))
    (rounds-to 1.58 (space-age/on-neptune seconds))))

(run-tests)
