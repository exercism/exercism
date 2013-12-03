open Core.Std

type planet = Mercury | Venus | Earth | Mars
            | Jupiter | Saturn | Neptune | Uranus

let earth_years seconds = seconds /. 31557600.0

let rel_years = function
    | Mercury -> 0.2408467
    | Venus   -> 0.61519726
    | Earth   -> 1.
    | Mars    -> 1.8808158
    | Jupiter -> 11.862615
    | Saturn  -> 29.447498
    | Uranus  -> 84.016846
    | Neptune -> 164.79132

let age_on planet seconds =
    let seconds' = Float.of_int seconds in
    match planet with
    | Earth -> earth_years seconds' 
    | _     -> earth_years seconds' /. rel_years planet
