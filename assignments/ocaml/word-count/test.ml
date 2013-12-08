open Core.Std
open OUnit2
open Word_count

module SMap = String.Map

let ae exp got _test_ctxt =
  let printer m = SMap.sexp_of_t Int.sexp_of_t m |> Sexp.to_string_hum ~indent:1 in
  assert_equal (SMap.of_alist_exn exp) got ~cmp:(SMap.equal (=)) ~printer

let tests =
  ["one word">::
     ae [("word", 1)] (word_count "word");
   "one of each">::
     ae [("one", 1); ("of", 1); ("each", 1)] (word_count "one of each");
   "multiple occurences">::
     ae [("one", 1); ("fish", 4); ("two", 1); ("red", 1); ("blue", 1)]
       (word_count "one fish two fish red fish blue fish");
   "ignore punctuation">::
     ae [("car", 1); ("carpet", 1); ("as", 1); ("java", 1); ("javascript", 1)]
       (word_count "car : carpet@as'java : javascript!!&@$%^&");
   "include numbers">::
     ae [("testing", 2); ("1", 1); ("2", 1)]
       (word_count "testing, 1, 2 testing");
   "normalize case">::
     ae [("go", 3)] (word_count "go Go GO");
  ]

let () =
  run_test_tt_main ("word_count tests" >::: tests)
