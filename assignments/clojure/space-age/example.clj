(ns space-age)

(def ^:private seconds-in-year (* 365.25 24 60 60))

(def ^:private factors {
  :mercury 0.2408467
  :venus   0.61519726
  :earth   1.0
  :mars    1.8808158
  :jupiter 11.862615
  :saturn  29.447498
  :uranus  84.016846
  :neptune 164.79132
})

(doseq [[planet factor] factors]
  (let [fn-name (symbol (str "on-" (name planet)))]
    (intern *ns* fn-name
            (fn [seconds]
                (/ (/ seconds seconds-in-year) factor)))))
