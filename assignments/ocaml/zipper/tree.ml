open Core.Std

type 'a t = { value : 'a; left : 'a t option; right : 'a t option }
with sexp

let rec equal veq a b =
  veq a.value b.value &&
  Option.equal (equal veq) a.left b.left &&
  Option.equal (equal veq) a.right b.right
