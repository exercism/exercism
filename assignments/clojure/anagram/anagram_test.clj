(load-file "anagram.clj")

(assert (= [] (anagram/anagrams-for "diaper" ["hello" "world" "zombies" "pants"])))
(assert (= ["ab"] (anagram/anagrams-for "ba" ["ab" "abc" "bac"])))
(assert (= [] (anagram/anagrams-for "abb" ["baa"])))
(assert (= ["inlets"] (anagram/anagrams-for "listen" ["enlists" "google" "inlets" "banana"])))
(assert (= ["gallery" "regally" "largely"]
           (anagram/anagrams-for "allergy" ["gallery" "ballerina" "regally" "clergy" "largely" "leading"])))
