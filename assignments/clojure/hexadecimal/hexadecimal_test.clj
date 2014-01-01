(ns hexadecimal.test (:require [clojure.test :refer :all]))
(load-file "hexadecimal.clj")

(deftest hex-to-int-test
  (is (= 1 (hex-to-int "1")))
  (is (= 12 (hex-to-int "c")))
  (is (= 16 (hex-to-int "10")))
  (is (= 175 (hex-to-int "af")))
  (is (= 256 (hex-to-int "100")))
  (is (= 105166 (hex-to-int "19ace")))
  (is (= 0 (hex-to-int "carrot")))
  (is (= 0 (hex-to-int "000000")))
  (is (= 16777215 (hex-to-int "ffffff")))
  (is (= 16776960 (hex-to-int "ffff00"))))

(run-tests)

