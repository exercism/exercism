open Core.Std

module CMap = Char.Map

let count s c =
    let f n c' = if c = c' then n + 1 else n in
    String.fold ~init:0 ~f s

let nucleotide_counts s =
    let f m c = CMap.change m c (function None -> Some 1 | Some n -> Some (n + 1)) in
    String.fold ~init:CMap.empty ~f s
