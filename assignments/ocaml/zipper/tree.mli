open Core.Std

type 'a t = { value : 'a; left : 'a t option; right : 'a t option }

include Equal.S1 with type 'a t := 'a t

val t_of_sexp : (Sexp.t -> 'a) -> Sexp.t -> 'a t
val sexp_of_t : ('a -> Sexp.t) -> 'a t -> Sexp.t
