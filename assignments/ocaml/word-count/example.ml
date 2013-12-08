open Core.Std

(* Get a list of all the words in the string.
 *
 * The list is in reverse order (more efficient to construct).
 *
 * This uses manual string slicing to avoid depending on any regex package
 * and because regexes are best avoided for simple tasks.
*)
let (words : string -> string list) s =
  let f i ((osi, l) as acc) c = match (osi, c) with
    | (None, c) when Char.is_alphanum c          -> (Some i, l)
    | (Some si, c) when not (Char.is_alphanum c) -> (None, String.slice s si i :: l)
    | _                                          -> acc
  in
  match String.foldi ~init:(None, []) ~f s with
  | (None, l)    -> l
  | (Some si, l) -> String.drop_prefix s si :: l

let word_count s = words s
                   |> List.map ~f:(fun x -> String.lowercase x, 1)
                   |> String.Map.of_alist_fold ~init:0 ~f:(+)
