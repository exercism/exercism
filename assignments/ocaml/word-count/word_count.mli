(** Word-count exercise *)

open Core.Std

(**
 * Count occurences of words (consisting of letters and numbers) in the string.
 *
 * Words will be converted to lower case before comparison and insertion in the
 * map.
 *)
val word_count : string -> int String.Map.t
