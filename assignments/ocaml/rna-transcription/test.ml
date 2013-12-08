open Core.Std
open OUnit2

let char_of_variant = function
  | `A -> 'A' | `C -> 'C' | `G -> 'G' | `T -> 'T' | `U -> 'U'
let printer l = List.map ~f:char_of_variant l |> String.of_char_list
let ae exp got _test_ctxt = assert_equal ~printer exp got

let tests =
  ["transcribes cytidine unchanged">::
    ae [`C] (Dna.to_rna [`C]);
   "transcribes guanosine unchanged">::
    ae [`G] (Dna.to_rna [`G]);
   "transcribes adenosie unchanged">::
    ae [`A] (Dna.to_rna [`A]);
   "transcribes thymidine to uracil">::
    ae [`U] (Dna.to_rna [`T]);
   "transcribes all occurences of thymidine to uracil">::
    ae [`A; `C; `G; `U; `G; `G; `U; `C; `U; `U; `A; `A]
       (Dna.to_rna [`A; `C; `G; `T; `G; `G; `T; `C; `T; `T; `A; `A])
  ]

let () =
  run_test_tt_main ("rna-transcription tests" >::: tests)
