(** Grade-school exercise *)
open Core.Std

type school

(** Create a new empty school *)
val create : unit -> school

(** Add a student to a school *)
val add : string -> int -> school -> school

(** Get all the students from a grade *)
val grade : int -> school -> string list

(** Sort the list of students in a grade, if necessary *)
val sort : school -> school

(** Return the list of grades and students as a map *)
val to_map : school -> (int, string list, Int.comparator) Map.t
