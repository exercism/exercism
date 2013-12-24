open Core.Std
open OUnit2

let format_board strings =
  let width = match strings with
    | [] -> 0
    | (s::_) -> String.length s in
  let border_line = "+" ^ String.make width '-' ^ "+\n" in
  let line s = "|" ^ s ^ "|\n" in
  "\n" ^ border_line ^ String.concat (List.map strings ~f:line) ^ border_line

(* Assert Equals *)
let ae exp got =
  assert_equal exp got ~cmp:(List.equal ~equal:String.equal) ~printer:format_board

let clean strings =
  List.map strings ~f:(String.map ~f:(function '*' -> '*' | _ -> ' '))

let tests =
  ["zero size board">::(fun _ ->
    ae [] (Minesweeper.annotate []));
   "empty board">::(fun _ ->
    let b = ["   ";
             "   ";
             "   "] in
    ae b (Minesweeper.annotate b));
   "board full of mines">::(fun _ ->
    let b = ["***";
             "***";
             "***"] in
    ae b (Minesweeper.annotate b));
   "surrounded">::(fun _ ->
    let b = ["***";
             "*8*";
             "***"] in
    ae b (Minesweeper.annotate (clean b)));
   "horizontal line">::(fun _ ->
    let b = ["1*2*1"] in
    ae b (Minesweeper.annotate (clean b)));
   "vertical line">::(fun _ ->
     let b = ["1";
              "*";
              "2";
              "*";
              "1"] in
    ae b (Minesweeper.annotate (clean b)));
   "cross">::(fun _ ->
    let b = [" 2*2 ";
             "25*52";
             "*****";
             "25*52";
             " 2*2 "] in
    ae b (Minesweeper.annotate (clean b)));
  ]

let () =
  run_test_tt_main ("minesweeper tests" >::: tests)
