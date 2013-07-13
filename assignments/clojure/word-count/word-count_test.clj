(load-file "word_count.clj")

(assert (= {"word" 1}
           (phrase/word-count "word")))

(assert (= {"one" 1 "of" 1 "each" 1}
           (phrase/word-count "one of each")))

(assert (= {"one" 1 "fish" 4 "two" 1 "red" 1 "blue" 1}
           (phrase/word-count "one fish two fish red fish blue fish")))

(assert (= {"car" 1, "carpet" 1 "as" 1 "java" 1 "javascript" 1}
           (phrase/word-count "car : carpet as java : javascript!!&@$%^&")))

(assert (= {"testing" 2 "1" 1 "2" 1}
           (phrase/word-count "testing, 1, 2 testing")))

(assert (= {"go" 3}
           (phrase/word-count "go Go GO")))
