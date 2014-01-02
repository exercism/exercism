(** list-ops exercise *)

(*
Please don't use any external modules (especially List) in your
implementation. The point of this exercise is to create these basic functions
yourself.

Note that `++` is a function from an external module (Pervasives, which is
automatically opened) and so shouldn't be used either.
*)

val length : 'a list -> int

val reverse : 'a list -> 'a list

val map : f:('a -> 'b) -> 'a list -> 'b list

val filter : f:('a -> bool) -> 'a list -> 'a list

val fold : init:'acc -> f:('acc -> 'a -> 'acc) -> 'a list -> 'acc

val append : 'a list -> 'a list -> 'a list

val concat : 'a list list -> 'a list
