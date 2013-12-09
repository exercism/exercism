open Core.Std
open OUnit2

module T = Tree
module Z = Zipper

(* Assert Equals Int *)
let aei exp got _test_ctxt =
  assert_equal exp got ~cmp:Int.equal ~printer:Int.to_string

(* Assert Equals Tree *)
let aet exp got _test_ctxt =
  let printer t = Tree.sexp_of_t Int.sexp_of_t t |> Sexp.to_string_hum in
  assert_equal exp got ~cmp:(Tree.equal Int.equal) ~printer

(* Assert Equals Tree Option *)
let aeto exp got _test_ctxt =
  let printer ot = Option.sexp_of_t (Tree.sexp_of_t Int.sexp_of_t) ot
                   |> Sexp.to_string_hum in
  assert_equal exp got ~cmp:(Option.equal (Tree.equal Int.equal)) ~printer

(* Assert Equals Zipper Option *)
let aezo exp got _test_ctxt =
  let printer ot = Option.sexp_of_t (Zipper.sexp_of_t Int.sexp_of_t) ot
                   |> Sexp.to_string_hum in
  assert_equal exp got ~cmp:(Option.equal (Zipper.equal Int.equal)) ~printer

let tree value left right = { T.value; left; right }
let node value left right = Some { T.value; left; right }
let leaf value            = Some { T.value; left = None; right = None }

let t1 = tree 1 (node 2 None     (leaf 3)) (leaf 4)
let t2 = tree 1 (node 5 None     (leaf 3)) (leaf 4)
let t3 = tree 1 (node 2 (leaf 5) (leaf 3)) (leaf 4)
let t4 = tree 1 (leaf 2)                   (leaf 4)

(* Unwrap Option *)
let uo o = Option.value_exn o

let tests =
  ["data is retained">::
     aet (Z.of_tree t1 |> Z.to_tree) t1;
   "left, right and value">::
     aei 3 (Z.of_tree t1 |> Z.left |> uo |> Z.right |> uo |> Z.value);
   "dead end">::
     aezo None (Z.of_tree t1 |> Z.left |> uo |> Z.left);
   "tree from deep focus">::
     aet t1 (Z.of_tree t1 |> Z.left |> uo |> Z.right |> uo |> Z.to_tree);
   "set_value">::
     aet t2 (Z.of_tree t1 |> Z.left |> uo |> Z.set_value 5 |> Z.to_tree);
   "set_left with Some">::
     aet t3 (Z.of_tree t1 |> Z.left |> uo |> Z.set_left (leaf 5) |> Z.to_tree);
   "set_right with None">::
     aet t4 (Z.of_tree t1 |> Z.left |> uo |> Z.set_right None |> Z.to_tree);
   "different paths to same zipper">::
     aezo (Z.of_tree t1 |> Z.right)
       (Z.of_tree t1 |> Z.left |> uo |> Z.up |> uo |> Z.right);
  ]

let () =
  run_test_tt_main ("zipper tests" >::: tests)
