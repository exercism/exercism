open Core.Std
open OUnit2

module CMap = Char.Map

(* Assert Int Equals *)
let aie exp got _test_ctxt =
  let printer = Int.to_string in
  assert_equal exp got ~printer
(* Assert Map Equals *)
let ame exp got =
  let printer m = CMap.sexp_of_t Int.sexp_of_t m |> Sexp.to_string_hum ~indent:1 in
  assert_equal exp got ~cmp:(CMap.equal (=)) ~printer

let tests =
  ["empty dna string has no adenosine">::
    aie 0 (Dna.count "" 'A');
   "empty dna string has no nucleotides">:: (fun _ ->
    let exp = CMap.empty in
    ame exp (Dna.nucleotide_counts ""));
   "repetitive cytidine gets counted">::
    aie 5 (Dna.count "CCCCC" 'C');
   "repetitive sequence has only guanosine">:: (fun _ ->
    let exp = CMap.singleton 'G' 8 in
    ame exp (Dna.nucleotide_counts "GGGGGGGG"));
   "counts only thymidine">::
    aie 1 (Dna.count "GGGGGTAACCCGG" 'T');
   "dna has no uracil">::
    aie 0 (Dna.count "GATTACA" 'U');
   "counts all nucleotides">:: (fun _ ->
    let s = "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC" in
    let exp = CMap.of_alist_exn [('A', 20); ('T', 21); ('C', 12); ('G', 17)] in
    ame exp (Dna.nucleotide_counts s))
  ]

let () =
  run_test_tt_main ("nucleotide-counts tests" >::: tests)
