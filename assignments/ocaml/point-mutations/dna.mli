type nucleotide = A | C | G | T

(** Compute the hammning distance between the two lists. *)
val hamming_distance : nucleotide list -> nucleotide list -> int
