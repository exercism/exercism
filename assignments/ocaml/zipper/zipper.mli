(** Zipper exercise interface *)
open Core.Std

(** The type of a zipper *)
type 'a t

(* You need to define an equal function *)
include Equal.S1 with type 'a t := 'a t

(* Sexp converters are also required. *)
val t_of_sexp : (Sexp.t -> 'a) -> Sexp.t -> 'a t
val sexp_of_t : ('a -> Sexp.t) -> 'a t -> Sexp.t

(** Create a zipper focussed on the root node. *)
val of_tree : 'a Tree.t -> 'a t

(** Get the complete tree from a zipper. *)
val to_tree : 'a t -> 'a Tree.t

(** Get the value of the focus node. *)
val value : 'a t -> 'a

(** Get the left child of the focus node, if any. *)
val left : 'a t -> 'a t option

(** Get the right child of the focus node, if any. *)
val right : 'a t -> 'a t option

(** Get the parent of the focus node, if any. *)
val up : 'a t -> 'a t option

(** Set the value of the focus node. *)
val set_value : 'a -> 'a t -> 'a t

(** Set the left child tree of the focus node. *)
val set_left : 'a Tree.t option -> 'a t -> 'a t

(** Set the right child tree of the focus node. *)
val set_right : 'a Tree.t option -> 'a t -> 'a t
