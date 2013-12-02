open Core.Std
open OUnit2

let ae exp got _test_ctxt = assert_equal ~printer:Int.to_string exp got

let dna_of_string s =
    let open Dna in
    let f = function
        | 'A' -> A
        | 'C' -> C
        | 'G' -> G
        | 'T' -> T
        | _   -> failwith "Big news! New nucleotide discovered" in
    String.to_list s |> List.map ~f

let hamdist a b = Dna.hamming_distance (dna_of_string a) (dna_of_string b)

let tests =
  ["no difference between empty strands">::
     ae 0 (hamdist "" "");
   "no difference between identical strands">::
     ae 0 (hamdist "GGACTAGA" 
                   "GGACTAGA");
   "hamming distance in off by one strand">::
     ae 19 (hamdist "GGACGGATTCTGACCTGGACTAATTTTGGGG"
                    "AGGACGGATTCTGACCTGGACTAATTTTGGGG");
   "small hamming distance in middle somewhere">::
     ae 1 (hamdist "GGACG"
                   "GGTCG");
   "larger distance">::
     ae 2 (hamdist "ACCAGGG"
                   "ACTATGG");
   "ignores extra length on other strand when longer">::
     ae 3 (hamdist "AAACTAGGGG"
                   "AGGCTAGCGGTAGGAC");
   "ignores extra length on original strand when longer">::
     ae 5 (hamdist "GACTACGGACAGGGTAGGGAAT"
                   "GACATCGCACACC")
  ]

let () =
  run_test_tt_main ("point-mutations tests" >::: tests)
