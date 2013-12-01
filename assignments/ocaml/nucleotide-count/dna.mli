open Core.Std

(* Count the number of times the nucleotide occurs in the string. *)
val count : string -> char -> int

(* Count the nucleotides in the string. *)
val nucleotide_counts : string -> int Char.Map.t
