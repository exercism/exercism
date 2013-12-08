open Core.Std
open OUnit2

module IMap = Int.Map

(* Assert list equals *)
let ale exp got = 
  let printer l = List.sexp_of_t String.sexp_of_t l
                  |> Sexp.to_string_hum ~indent:1 in
  assert_equal exp got ~printer

(* Assert map equals *)
let ame exp got =
  let printer m = 
      Map.to_alist m
      |> List.sort ~cmp:compare
      |> List.sexp_of_t (Tuple2.sexp_of_t Int.sexp_of_t (List.sexp_of_t String.sexp_of_t))
      |> Sexp.to_string_hum ~indent:1 in
  assert_equal exp got ~cmp:(Map.equal (=)) ~printer

(* The tests never reuse a school value, so if you like you can use destructive
 * modification (i.e. mutable data structures). For the same reason
 * School.create takes a unit argument.
 *
 * For those who wonder why the test doesn't use objects, it's to not force
 * the use of objects. You can still use them internally though. 
 *)

let tests =
  ["add student">:: (fun _ ->
       let got = School.create ()
                 |> School.add "Aimee" 2 in
       ame (IMap.of_alist_exn [(2, ["Aimee"])])
           (School.to_map got));
   "add more students in same class">:: (fun _ ->
       let got = School.create ()
                 |> School.add "James" 2
                 |> School.add "Blair" 2
                 |> School.add "Paul" 2 in
       ame (IMap.of_alist_exn [(2, ["Blair"; "James"; "Paul"])])
           (School.to_map got |> Map.map ~f:(List.sort ~cmp:compare)));
   "add students to different grades">:: (fun _ ->
       let got = School.create ()
                 |> School.add "Chelsea" 3
                 |> School.add "Logan" 7 in
       ame (IMap.of_alist_exn [(3, ["Chelsea"]); (7, ["Logan"])])
           (School.to_map got |> Map.map ~f:(List.sort ~cmp:compare)));
   "get students in a grade">:: (fun _ ->
       let got = School.create ()
                 |> School.add "Franklin" 5
                 |> School.add "Bradley" 5
                 |> School.add "Jeff" 1
                 |> School.grade 5 in
       ale ["Bradley"; "Franklin"]
           (List.sort ~cmp:compare got));
   "get students in a non existant grade">:: (fun _ ->
       ale [] (List.sort ~cmp:compare (School.create () |> School.grade 2)));
   "sort school">:: (fun _ ->
       let got = School.create ()
                 |> School.add "Christopher" 4
                 |> School.add "Jennifer" 4
                 |> School.add "Kareem" 6
                 |> School.add "Kyle" 3
                 |> School.sort in
       ame (IMap.of_alist_exn [(3, ["Kyle"]);
                               (4, ["Christopher"; "Jennifer"]);
                               (6, ["Kareem"])])
           (School.to_map got |> Map.map ~f:(List.sort ~cmp:compare)));
  ]

let () =
  run_test_tt_main ("grade-school tests" >::: tests)
