(load-file "crypto_square.clj")

(assert (= "splunk" (normalize-plaintext "s#!@$%plunk")))
(assert (= "123go" (normalize-plaintext "1, 2, 3 GO!")))

(assert (= 2 (square-size "1234")))
(assert (= 3 (square-size "123456789")))
(assert (= 4 (square-size "123456789abc")))

(assert (= ["neverv", "exthin", "eheart", "withid", "lewoes"]
           (plaintext-segments "Never vex thine heart with idle woes.")))
(assert (= ["zomg", "zomb", "ies"]
           (plaintext-segments "ZOMG! ZOMBIES!!!")))

(assert (= "tasneyinicdsmiohooelntuillibsuuml"
           (ciphertext "Time is an illusion. Lunchtime doubly so.")))
(assert (= "wneiaweoreneawssciliprerlneoidktcms"
           (ciphertext "We all know interspecies romance is weird.")))
(assert (= "msemo aanin dninn dlaet ltshu i"
           (normalize-ciphertext "Madness, and then illumination.")))
(assert (= "vrela epems etpao oirpo"
           (normalize-ciphertext "Vampires are people too!")))
