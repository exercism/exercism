open Core.Std

let is_empty = String.for_all ~f:Char.is_whitespace

let is_shouting s =
  String.exists ~f:Char.is_alpha s &&
  String.for_all ~f:(fun c -> not (Char.is_alpha c) || Char.is_uppercase c) s

let is_question = String.is_suffix ~suffix:"?"

let response_for = function
  | s when is_empty s    -> "Fine. Be that way!"
  | s when is_shouting s -> "Woah, chill out!"
  | s when is_question s -> "Sure."
  | _                    -> "Whatever."
