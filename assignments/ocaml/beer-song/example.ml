open Core.Std

let bottles = function
    | 0 -> "no more bottles"
    | 1 -> "1 bottle"
    | n -> Int.to_string n ^ " bottles"

let line1 n =
    let b = bottles n in
    sprintf "%s of beer on the wall, %s of beer.\n" b b

let line2 n =
    sprintf "Take %s down and pass it around, %s of beer on the wall.\n"
            (if n > 0 then "one" else "it") (bottles n)

let verse = function
    | 0 -> String.capitalize (line1 0) ^
           "Go to the store and buy some more, 99 bottles of beer on the wall.\n"
    | n -> line1 n ^ line2 (n-1)

let sing ~from:from ~until:until =
    List.map (List.range ~stride:(-1) ~stop:`inclusive from until)
             ~f:(fun n -> verse n ^ "\n")
    |> String.concat
