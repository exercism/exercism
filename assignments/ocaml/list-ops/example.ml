let length l =
  let rec go acc = function
    | [] -> acc
    | _ :: t -> go (acc+1) t in
  go 0 l

let reverse l =
  let rec go acc = function
    | [] -> acc
    | h :: t -> go (h :: acc) t in
  go [] l

let map ~f l =
  let rec go acc = function
    | [] -> acc
    | h :: t -> go (f h :: acc) t in
  go [] l |> reverse

let filter ~f l =
  let rec go acc = function
    | [] -> acc
    | h :: t when f h -> go (h :: acc) t
    | _ :: t -> go acc t in
  go [] l |> reverse

let rec fold ~init:acc ~f = function
  | [] -> acc
  | (h :: t) -> fold ~init:(f acc h) ~f t

let append a b =
  let rec go acc = function
  | [] -> acc
  | h :: t -> go (h :: acc) t in
  go b (reverse a)

let concat ll =
  reverse ll |> fold ~init:[] ~f:(fun acc x -> append x acc)

(* vim:et:ts=2:sw=2:sts=2
 *)
