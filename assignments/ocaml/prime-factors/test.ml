open Core.Std
open OUnit2

(* Assert Equals *)
let ae exp got _test_ctxt =
  let printer = List.to_string ~f:Int64.to_string in
  assert_equal exp got ~printer

(* 64 bits integers are needed for the last number.
 *
 * If you happen to use a 64 bits machine normal ints would do as well, but this
 * works for everybody.
 *)
let test_pairs =
    [([],                    1L);
     ([2L],                  2L);
     ([3L],                  3L);
     ([2L; 2L],              4L);
     ([2L; 2L; 2L],          8L);
     ([3L; 3L],              9L);
     ([3L; 3L; 3L],          27L);
     ([5L; 5L; 5L; 5L],      625L);
     ([5L; 17L; 23L; 461L],  901255L);
     ([11L; 9539L; 894119L], 93819012551L)]

let tests =
  let f (l, n) = (Int64.to_string n) >:: ae l (Prime_factors.factors_of n) in
  List.map ~f test_pairs

let () =
  run_test_tt_main ("prime-factors tests" >::: tests)
