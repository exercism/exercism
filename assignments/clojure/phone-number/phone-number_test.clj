(ns phone-number.test (:use clojure.test))
(load-file "phone.clj")

(deftest cleans-number
  (is (= "1234567890" (phone/number "(123) 456-7890"))))

(deftest cleans-number-with-dots
  (is (= "1234567890" (phone/number "123.456.7890"))))

(deftest valid-when-11-digits-and-first-is-1
  (is (= "1234567890" (phone/number "11234567890"))))

(deftest invalid-when-11-digits
  (is (= "0000000000" (phone/number "21234567890"))))

(deftest invalid-when-9-digits
  (is (= "0000000000" (phone/number "123456789"))))

(deftest area-code
  (is (= "123" (phone/area-code "1234567890"))))

(deftest pretty-print
  (is (= "(123) 456-7890" (phone/pretty-print "1234567890"))))

(deftest pretty-print-with-full-us-phone-number
  (is (= "(123) 456-7890" (phone/pretty-print "11234567890"))))

(run-tests)
