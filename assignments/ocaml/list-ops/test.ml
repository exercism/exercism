open Core.Std
open OUnit2

module L = List_ops

let aei exp got _test_ctxt = assert_equal ~printer:Int.to_string exp got

let ael exp got _test_ctxt =
  (* There's a little problem with the [List.to_string] function apparently
     getting a stack overflow on very long lists. *)
  if List.length exp < 1000 then
    assert_equal ~printer:(List.to_string ~f:Int.to_string) exp got
  else
    assert_equal exp got

let is_odd n = n % 2 = 1

let tests =
  ["length of empty list">::
   aei 0 (L.length []);
   "length of normal list">::
   aei 4 (L.length [1;3;5;7]);
   "length of huge list">::
   aei 1_000_000 (L.length (List.range 0 1_000_000));
   "reverse of empty list">::
   ael [] (L.reverse []);
   "reverse of normal list">::
   ael [7;5;3;1] (L.reverse [1;3;5;7]);
   "reverse of huge list">::
   ael (List.range ~start:`exclusive ~stop:`inclusive ~stride:(-1) 1_000_000 0)
     (L.reverse (List.range 0 1_000_000));
   "map of empty list">::
   ael [] (L.map ~f:((+) 1) []);
   "map of normal list">::
   ael [2;4;6;8] (L.map ~f:((+) 1) [1;3;5;7]);
   "map of huge list">::
   ael (List.range 1 1_000_001) (L.map ~f:((+) 1) (List.range 0 1_000_000));
   "filter of empty list">::
   ael [] (L.filter ~f:is_odd []);
   "filter of normal list">::
   ael [1;3] (L.filter ~f:is_odd [1;2;3;4]);
   "filter of huge list">::
   ael (List.range ~stride:2 1 1_000_000)
     (L.filter ~f:is_odd (List.range 0 1_000_000));
   "fold of empty list">::
   aei 0 (L.fold ~init:0 ~f:(+) []);
   "fold of normal list">::
   aei 7 (L.fold ~init:(-3) ~f:(+) [1;2;3;4]);
   "fold of huge list">::
   aei (List.fold ~init:0 ~f:(+) (List.range 0 1_000_000))
     (L.fold ~init:0 ~f:(+) (List.range 0 1_000_000));
   "append of empty lists">::
   ael [] (L.append [] []);
   "append of empty and non-empty list">::
   ael [1;2;3;4] (L.append [] [1;2;3;4]);
   "append of non-empty and empty list">::
   ael [1;2;3;4] (L.append [1;2;3;4] []);
   "append of non-empty lists">::
   ael [1;2;3;4;5] (L.append [1;2;3] [4;5]);
   "append of huge lists">::
   ael (List.range 0 2_000_000)
     (L.append (List.range 0 1_000_000) (List.range 1_000_000 2_000_000));
   "concat of empty list of lists">::
   ael [] (L.concat []);
   "concat of normal list of lists">::
   ael [1;2;3;4;5;6] (L.concat [[1;2];[3];[];[4;5;6]]);
   "concat of huge list of small lists">::
   ael (List.range 0 1_000_000)
     (L.concat (List.map ~f:(fun x -> [x]) (List.range 0 1_000_000)));
   "concat of small list of huge lists">::
   ael (List.range 0 1_000_000)
     (L.concat 
        (List.map ~f:(fun x -> List.range (x*100_000) ((x+1)*100_000))
           (List.range 0 10)))
  ]

let () =
  run_test_tt_main ("list-ops tests" >::: tests)

(* vim:et:ts=2:sw=2:sts=2
*)
