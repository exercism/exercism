open Core.Std

type field =
  | Mine
  | Empty of int (* Empty spot, number is adjacent mines *)

type board = { fields: field array array; width: int; height: int }

let board_of_strings strings =
  let to_field = function
    | '*' -> Mine
    | _   -> Empty 0 in
  let f s = String.to_list s |> List.map ~f:to_field |> Array.of_list in
  let fields = List.map strings ~f |> Array.of_list in
  let height = Array.length fields in
  let width = if height > 0 then Array.length fields.(0) else 0 in
  { fields; width; height }

let strings_of_board board =
  let to_char = function
    | Mine    -> '*'
    | Empty 0 -> ' '
    | Empty n -> Char.of_int_exn (Char.to_int '0' + n) in
  let f a = Array.to_list a |> List.map ~f:to_char |> String.of_char_list in
  Array.to_list board.fields |> List.map ~f

let adjacent_offsets =
  let open List in
  ([-1; 0; 1] >>= fun x ->
   [-1; 0; 1] >>= fun y ->
   return (x, y))
  |> List.filter ~f:(fun c -> c <> (0, 0))

let mark_mine board c =
  let valid_coord (x, y) = x >= 0 && x < board.width && y >= 0 && y < board.height in
  let add_vec (ax, ay) (bx, by) = (ax + bx, ay + by) in
  let inc_field = function
    | Mine -> Mine
    | Empty n -> Empty (n + 1) in
  List.map adjacent_offsets ~f:(fun o -> add_vec c o)
  |> List.filter ~f:valid_coord
  |> List.iter ~f:(fun (x, y) -> board.fields.(y).(x) <- inc_field board.fields.(y).(x))

let annotate strings =
  let board = board_of_strings strings in
  for x = 0 to board.width - 1 do
    for y = 0 to board.height - 1 do
      match board.fields.(y).(x) with
      | Mine    -> mark_mine board (x, y)
      | Empty _ -> ()
    done
  done;
  strings_of_board board
