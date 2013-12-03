open Core.Std

type school = string list Int.Map.t

let create _ = Int.Map.empty

let add s g school = Map.add_multi ~key:g ~data:s school

let grade g school = Map.find school g |> Option.value ~default:[]

let sort school = Map.map ~f:(List.sort ~cmp:compare) school

let to_map = ident
