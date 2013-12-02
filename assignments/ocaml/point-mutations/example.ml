open Core.Std

type nucleotide = A | C | G | T

let diff a b = List.zip_exn a b |> List.count ~f:(fun (a', b') -> a' <> b')

(* List.zip only works for lists of the same length. *)
let hamming_distance a b =
    let la = List.length a in
    let lb = List.length b in
    if la = lb then
        diff a b
    else if la < lb then
        diff a (List.take b la)
    else
        diff (List.take a lb) b
