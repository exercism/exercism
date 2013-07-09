(load-file "leap_year.clj")

(assert (leap-year 1996))
(assert (not (leap-year 1997)))
(assert (not (leap-year 1900)))
(assert (leap-year 2000))
