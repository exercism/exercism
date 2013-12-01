open Core.Std

type dna = [ `A | `C | `G | `T ]
type rna = [ `A | `C | `G | `U ]

let to_rna = List.map ~f:(function
    | `T -> `U
    | `A -> `A
    | `C -> `C
    | `G -> `G)
