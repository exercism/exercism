(ns largest_series_product.test (:require [clojure.test :refer :all]))
(load-file "series.clj")

(deftest largest_series_tests
  (is (= (range 0 10) (digits "0123456789")))
  (is (= (range 9 -1 -1) (digits "9876543210")))
  (is (= (range 8 3 -1) (digits "87654")))
  (is (= [9 3 6 9 2 3 4 6 8] (digits "936923468")))
  (is (= [[9 8] [8 2] [2 7] [7 3] [3 4] [4 6] [6 3]] (slices 2 "98273463")))
  (is (= [[9 8 2] [8 2 3] [2 3 4] [3 4 7]] (slices 3 "982347")))
  (is (= 72 (largest-product 2 "0123456789")))
  (is (= 2 (largest-product 2 "12")))
  (is (= 9 (largest-product 2 "19")))
  (is (= 48 (largest-product 2 "576802143")))
  (is (= 504 (largest-product 3 "0123456789")))
  (is (= 270 (largest-product 3 "1027839564")))
  (is (= 15120 (largest-product 5 "0123456789")))
  (is (= 23520 (largest-product 6 "73167176531330624919225119674426574742355349194934")))
  (is (= 28350 ( largest-product 6 "52677741234314237566414902593461595376319419139427")))
  (is (= 1 (largest-product 0 "")))
  ;; unlike the Ruby implementation no error is expected for too small input
  (is (= 1 (largest-product 4 "123")))
  ;; edge case :)
  (is (= 0 (largest-product 2 "00"))))

(run-tests)

