(** Space-age exercise *)

type planet = Mercury | Venus | Earth | Mars
            | Jupiter | Saturn | Neptune | Uranus

(** Convert seconds to years on the specified planet *)
val age_on : planet -> int -> float
