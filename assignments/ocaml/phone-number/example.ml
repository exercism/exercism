open Core.Std

let number s =
  let s' = String.filter ~f:Char.is_digit s in
  match String.length s' with
  | 10                            -> Some s'
  | 11 when String.get s' 0 = '1' -> Some (String.drop_prefix s' 1)
  | _                             -> None

let split_number s =
  (String.slice s 0 3, String.slice s 3 6, String.slice s 6 10)

let area_code s = 
  let open Option in (* >>| for Option *)
  number s >>| split_number >>| (fun (area, _, _) -> area)

let pretty s =
  let open Option in
  number s
  >>| split_number
  >>| fun (area, exch, subscr) -> sprintf "(%s) %s-%s" area exch subscr
