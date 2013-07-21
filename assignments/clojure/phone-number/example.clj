(ns phone)
(require '[clojure.string :as str])

(defn- digits-only
  [input]
  (str/replace input #"\D" ""))

(defn- extract-parts
  [input]
  (if-let [matches (re-find #"^1?(...)(...)(....)$" input)]
    (rest matches)
    ["000" "000" "0000"]))

(defn- parts
  [input]
  (-> input
      digits-only
      extract-parts))

(defn number [input]
  (str/join (parts input)))

(defn area-code [input]
  (first (parts input)))

(defn pretty-print [input]
  (let [[area-code exchange subscriber] (parts input)]
    (str "(" area-code ") " exchange "-" subscriber)))

