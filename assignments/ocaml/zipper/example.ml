open Core.Std

type 'a trail =
  | L of 'a * 'a Tree.t option * 'a trail (* Left path taken *)
  | R of 'a * 'a Tree.t option * 'a trail (* Right path taken *)
  | T                                     (* Top level (root) *)
with sexp

type 'a t = { value: 'a;
              left: 'a Tree.t option;
              right: 'a Tree.t option; trail: 'a trail } with sexp

let rec equal veq a b =
  veq a.value b.value &&
  Option.equal (Tree.equal veq) a.left b.left &&
  Option.equal (Tree.equal veq) a.right b.right &&
  trail_equal veq a.trail b.trail
and trail_equal veq a b = match (a, b) with
  | (L (av, ar, azt), L (bv, br, bzt)) ->
    veq av bv && Option.equal (Tree.equal veq) ar br && trail_equal veq azt bzt
  | (R (av, al, azt), R (bv, bl, bzt)) ->
    veq av bv && Option.equal (Tree.equal veq) al bl && trail_equal veq azt bzt
  | (T, T) -> true
  | (_, _) -> false

let of_tree t =
  { value = t.Tree.value; left = t.Tree.left; right = t.Tree.right; trail = T }

let to_tree z =
  let rec go t = function
    | L (pv, pr, pzt) -> go { Tree.value = pv; left = Some t; right = pr } pzt
    | R (pv, pl, pzt) -> go { Tree.value = pv; left = pl; right = Some t } pzt
    | T               -> t
  in
  go { Tree.value = z.value; left = z.left; right = z.right } z.trail

let value z = z.value

let left = function
  | { left = None; _ }        -> None
  | { left = Some t; _ } as z ->
    Some { value = t.Tree.value; left = t.Tree.left; right = t.Tree.right;
           trail = L (z.value, z.right, z.trail) }

let right = function
  | { right = None; _ }        -> None
  | { right = Some t; _ } as z ->
    Some { value = t.Tree.value; left = t.Tree.left; right = t.Tree.right;
           trail = R (z.value, z.left, z.trail) }

let up { value; left; right; trail } = match trail with
  | L (pv, pr, pzt) -> Some { value = pv; right = pr; trail = pzt;
                              left = Some { Tree.value; left; right } }
  | R (pv, pl, pzt) -> Some { value = pv; left = pl; trail = pzt;
                              right = Some { Tree.value; left; right } }
  | T               -> None

let set_value value z = { z with value }

let set_left left z = { z with left }

let set_right right z = { z with right }
