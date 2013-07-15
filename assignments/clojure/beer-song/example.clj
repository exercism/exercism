(ns beer)

(defn- bottles [number]
  (str "bottle" (if (= number 1) "" "s")))

(defn- count-bottles [number]
  (if (= 0 number) "no more" number))

(defn- stanza [number]
  (if (>= number 0)
      (str (count-bottles number) " " (bottles number) " of beer")
      (stanza 99)))

(defn- it [number]
  (if (> number 1) "one" "it"))

(defn- action [number]
  (if (> number 0)
      (str "Take " (it number) " down and pass it around")
      "Go to the store and buy some more"))

(defn verse
  "generate a verse of \"99 Bottles Of Beer\""
  [number]
  (str (clojure.string/capitalize (stanza number)) " on the wall, "
       (stanza number) ".\n"
       (action number) ", "
       (stanza (dec number)) " on the wall.\n"))

(defn sing
  ([start-from]
    (sing start-from 0))

  ([start-from down-to]
    (apply str (->> (range down-to (inc start-from))
                    reverse
                    (map #(str (verse %1) "\n"))))))
