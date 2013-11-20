open Core.Std

let to_sorted_list s = String.to_list s |> List.sort ~cmp:Char.compare

let anagrams target candidates =
  let target_lc = String.lowercase target in
  let target_sorted = to_sorted_list target_lc in
  List.map ~f:(fun c -> (c, String.lowercase c)) candidates
  |> List.filter ~f:(fun (_, lc) ->
      to_sorted_list lc = target_sorted && lc <> target_lc)
  |> List.map ~f:fst
