(ns meetup.test (:require [clojure.test :refer :all]))
(load-file "meetup.clj")

(deftest monteenth-of-may-2013
  (is (= [2013 5 13] (meetup/monteenth 5 2013))))

(deftest monteenth-of-august-2013
  (is (= [2013 8 19] (meetup/monteenth 8 2013))))

(deftest monteenth-of-september-2013
  (is (= [2013 9 16] (meetup/monteenth 9 2013))))

(deftest tuesteenth-of-march-2013
  (is (= [2013 3 19] (meetup/tuesteenth 3 2013))))

(deftest tuesteenth-of-april-2013
  (is (= [2013 4 16] (meetup/tuesteenth 4 2013))))

(deftest tuesteenth-of-august-2013
  (is (= [2013 8 13] (meetup/tuesteenth 8 2013))))

(deftest wednesteenth-of-january-2013
  (is (= [2013 1 16] (meetup/wednesteenth 1 2013))))

(deftest wednesteenth-of-february-2013
  (is (= [2013 2 13] (meetup/wednesteenth 2 2013))))

(deftest wednesteenth-of-june-2013
  (is (= [2013 6 19] (meetup/wednesteenth 6 2013))))

(deftest thursteenth-of-may-2013
  (is (= [2013 5 16] (meetup/thursteenth 5 2013))))

(deftest thursteenth-of-june-2013
  (is (= [2013 6 13] (meetup/thursteenth 6 2013))))

(deftest thursteenth-of-september-2013
  (is (= [2013 9 19] (meetup/thursteenth 9 2013))))

(deftest friteenth-of-april-2013
  (is (= [2013 4 19] (meetup/friteenth 4 2013))))

(deftest friteenth-of-august-2013
  (is (= [2013 8 16] (meetup/friteenth 8 2013))))

(deftest friteenth-of-september-2013
  (is (= [2013 9 13] (meetup/friteenth 9 2013))))

(deftest saturteenth-of-february-2013
  (is (= [2013 2 16] (meetup/saturteenth 2 2013))))

(deftest saturteenth-of-april-2013
  (is (= [2013 4 13] (meetup/saturteenth 4 2013))))

(deftest saturteenth-of-october-2013
  (is (= [2013 10 19] (meetup/saturteenth 10 2013))))

(deftest sunteenth-of-map-2013
  (is (= [2013 5 19] (meetup/sunteenth 5 2013))))

(deftest sunteenth-of-june-2013
  (is (= [2013 6 16] (meetup/sunteenth 6 2013))))

(deftest sunteenth-of-october-2013
  (is (= [2013 10 13] (meetup/sunteenth 10 2013))))

(deftest first-monday-of-march-2013
  (is (= [2013 3 4] (meetup/first-monday 3 2013))))

(deftest first-monday-of-april-2013
  (is (= [2013 4 1] (meetup/first-monday 4 2013))))

(deftest first-tuesday-of-may-2013
  (is (= [2013 5 7] (meetup/first-tuesday 5 2013))))

(deftest first-tuesday-of-june-2013
  (is (= [2013 6 4] (meetup/first-tuesday 6 2013))))

(deftest first-wednesday-of-july-2013
  (is (= [2013 7 3] (meetup/first-wednesday 7 2013))))

(deftest first-wednesday-of-august-2013
  (is (= [2013 8 7] (meetup/first-wednesday 8 2013))))

(deftest first-thursday-of-september-2013
  (is (= [2013 9 5] (meetup/first-thursday 9 2013))))

(deftest first-thursday-of-october-2013
  (is (= [2013 10 3] (meetup/first-thursday 10 2013))))

(deftest first-friday-of-november-2013
  (is (= [2013 11 1] (meetup/first-friday 11 2013))))

(deftest first-friday-of-december-2013
  (is (= [2013 12 6] (meetup/first-friday 12 2013))))

(deftest first-saturday-of-january-2013
  (is (= [2013 1 5] (meetup/first-saturday 1 2013))))

(deftest first-saturday-of-february-2013
  (is (= [2013 2 2] (meetup/first-saturday 2 2013))))

(deftest first-sunday-of-march-2013
  (is (= [2013 3 3] (meetup/first-sunday 3 2013))))

(deftest first-sunday-of-april-2013
  (is (= [2013 4 7] (meetup/first-sunday 4 2013))))

(deftest second-monday-of-march-2013
  (is (= [2013 3 11] (meetup/second-monday 3 2013))))

(deftest second-monday-of-april-2013
  (is (= [2013 4 8] (meetup/second-monday 4 2013))))

(deftest second-tuesday-of-may-2013
  (is (= [2013 5 14] (meetup/second-tuesday 5 2013))))

(deftest second-tuesday-of-june-2013
  (is (= [2013 6 11] (meetup/second-tuesday 6 2013))))

(deftest second-wednesday-of-july-2013
  (is (= [2013 7 10] (meetup/second-wednesday 7 2013))))

(deftest second-wednesday-of-august-2013
  (is (= [2013 8 14] (meetup/second-wednesday 8 2013))))

(deftest second-thursday-of-september-2013
  (is (= [2013 9 12] (meetup/second-thursday 9 2013))))

(deftest second-thursday-of-october-2013
  (is (= [2013 10 10] (meetup/second-thursday 10 2013))))

(deftest second-friday-of-november-2013
  (is (= [2013 11 8] (meetup/second-friday 11 2013))))

(deftest second-friday-of-december-2013
  (is (= [2013 12 13] (meetup/second-friday 12 2013))))

(deftest second-saturday-of-january-2013
  (is (= [2013 1 12] (meetup/second-saturday 1 2013))))

(deftest second-saturday-of-february-2013
  (is (= [2013 2 9] (meetup/second-saturday 2 2013))))

(deftest second-sunday-of-march-2013
  (is (= [2013 3 10] (meetup/second-sunday 3 2013))))

(deftest second-sunday-of-april-2013
  (is (= [2013 4 14] (meetup/second-sunday 4 2013))))

(deftest third-monday-of-march-2013
  (is (= [2013 3 18] (meetup/third-monday 3 2013))))

(deftest third-monday-of-april-2013
  (is (= [2013 4 15] (meetup/third-monday 4 2013))))

(deftest third-tuesday-of-may-2013
  (is (= [2013 5 21] (meetup/third-tuesday 5 2013))))

(deftest third-tuesday-of-june-2013
  (is (= [2013 6 18] (meetup/third-tuesday 6 2013))))

(deftest third-wednesday-of-july-2013
  (is (= [2013 7 17] (meetup/third-wednesday 7 2013))))

(deftest third-wednesday-of-august-2013
  (is (= [2013 8 21] (meetup/third-wednesday 8 2013))))

(deftest third-thursday-of-september-2013
  (is (= [2013 9 19] (meetup/third-thursday 9 2013))))

(deftest third-thursday-of-october-2013
  (is (= [2013 10 17] (meetup/third-thursday 10 2013))))

(deftest third-friday-of-november-2013
  (is (= [2013 11 15] (meetup/third-friday 11 2013))))

(deftest third-friday-of-december-2013
  (is (= [2013 12 20] (meetup/third-friday 12 2013))))

(deftest third-saturday-of-january-2013
  (is (= [2013 1 19] (meetup/third-saturday 1 2013))))

(deftest third-saturday-of-february-2013
  (is (= [2013 2 16] (meetup/third-saturday 2 2013))))

(deftest third-sunday-of-march-2013
  (is (= [2013 3 17] (meetup/third-sunday 3 2013))))

(deftest third-sunday-of-april-2013
  (is (= [2013 4 21] (meetup/third-sunday 4 2013))))

(deftest fourth-monday-of-march-2013
  (is (= [2013 3 25] (meetup/fourth-monday 3 2013))))

(deftest fourth-monday-of-april-2013
  (is (= [2013 4 22] (meetup/fourth-monday 4 2013))))

(deftest fourth-tuesday-of-may-2013
  (is (= [2013 5 28] (meetup/fourth-tuesday 5 2013))))

(deftest fourth-tuesday-of-june-2013
  (is (= [2013 6 25] (meetup/fourth-tuesday 6 2013))))

(deftest fourth-wednesday-of-july-2013
  (is (= [2013 7 24] (meetup/fourth-wednesday 7 2013))))

(deftest fourth-wednesday-of-august-2013
  (is (= [2013 8 28] (meetup/fourth-wednesday 8 2013))))

(deftest fourth-thursday-of-september-2013
  (is (= [2013 9 26] (meetup/fourth-thursday 9 2013))))

(deftest fourth-thursday-of-october-2013
  (is (= [2013 10 24] (meetup/fourth-thursday 10 2013))))

(deftest fourth-friday-of-november-2013
  (is (= [2013 11 22] (meetup/fourth-friday 11 2013))))

(deftest fourth-friday-of-december-2013
  (is (= [2013 12 27] (meetup/fourth-friday 12 2013))))

(deftest fourth-saturday-of-january-2013
  (is (= [2013 1 26] (meetup/fourth-saturday 1 2013))))

(deftest fourth-saturday-of-february-2013
  (is (= [2013 2 23] (meetup/fourth-saturday 2 2013))))

(deftest fourth-sunday-of-march-2013
  (is (= [2013 3 24] (meetup/fourth-sunday 3 2013))))

(deftest fourth-sunday-of-april-2013
  (is (= [2013 4 28] (meetup/fourth-sunday 4 2013))))

(deftest last-monday-of-march-2013
  (is (= [2013 3 25] (meetup/last-monday 3 2013))))

(deftest last-monday-of-april-2013
  (is (= [2013 4 29] (meetup/last-monday 4 2013))))

(deftest last-tuesday-of-may-2013
  (is (= [2013 5 28] (meetup/last-tuesday 5 2013))))

(deftest last-tuesday-of-june-2013
  (is (= [2013 6 25] (meetup/last-tuesday 6 2013))))

(deftest last-wednesday-of-july-2013
  (is (= [2013 7 31] (meetup/last-wednesday 7 2013))))

(deftest last-wednesday-of-august-2013
  (is (= [2013 8 28] (meetup/last-wednesday 8 2013))))

(deftest last-thursday-of-september-2013
  (is (= [2013 9 26] (meetup/last-thursday 9 2013))))

(deftest last-thursday-of-october-2013
  (is (= [2013 10 31] (meetup/last-thursday 10 2013))))

(deftest last-friday-of-november-2013
  (is (= [2013 11 29] (meetup/last-friday 11 2013))))

(deftest last-friday-of-december-2013
  (is (= [2013 12 27] (meetup/last-friday 12 2013))))

(deftest last-saturday-of-january-2013
  (is (= [2013 1 26] (meetup/last-saturday 1 2013))))

(deftest last-saturday-of-february-2013
  (is (= [2013 2 23] (meetup/last-saturday 2 2013))))

(deftest last-sunday-of-march-2013
  (is (= [2013 3 31] (meetup/last-sunday 3 2013))))

(deftest last-sunday-of-april-2013
  (is (= [2013 4 28] (meetup/last-sunday 4 2013))))

(run-tests)
