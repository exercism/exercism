open Core.Std
open OUnit2
open Anagram

let ae exp got _test_ctxt =
  let printer = List.to_string ~f:String.to_string in
  assert_equal exp got ~cmp:(List.equal ~equal:String.equal) ~printer

let tests =
  ["no matches">::
     ae [] (anagrams "diaper" ["hello"; "world"; "zombies"; "pants"]);
   "detect simple anagrams">::
     ae ["tan"] (anagrams "ant" ["tan"; "stand"; "at"]);
   "detect multiple anagrams">::
     ae ["stream"; "maters"] (anagrams "master" ["stream"; "pigeon"; "maters"]);
   "do not detect anagram subsets">::
     ae [] (anagrams "good" ["dog"; "goody"]);
   "multiple anagrams">::
     ae ["gallery"; "regally"; "largely"]
       (anagrams "allergy" ["gallery"; "ballerina"; "regally"; "clergy";
                            "largely"; "leading"]);
   "detect anagrams case-insensitively">::
     ae ["Carthorse"]
       (anagrams "Orchestra" ["cashregister"; "Carthorse"; "radishes"]);
   "anagrams must not be the source word">::
     ae [] (anagrams "banana" ["banana"]);
   "anagrams must not be the source word case-insensitively">::
     ae [] (anagrams "banana" ["Banana"]);
   "anagrams must use all letters exactly once">::
     ae [] (anagrams "patter" ["tapper"]);
  ]

let () =
  run_test_tt_main ("anagrams tests" >::: tests)
