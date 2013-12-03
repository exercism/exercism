open Core.Std
open OUnit2
open Space_age

(* Assert In Delta *)
let aid ~d:delta exp got =
  let msg = sprintf "Expected %f got %f, difference is greater than %f"
                    exp got delta in
  assert_bool msg (cmp_float ~epsilon:delta exp got)

let tests =
  ["age in Earth years">:: (fun _ ->
    let input = 1_000_000_000 in
    aid ~d:0.005 31.69 (age_on Earth input));
   "age in Mercury years">:: (fun _ ->
    let input = 2_134_835_688 in
    aid ~d:0.005 67.65 (age_on Earth input);
    aid ~d:0.005 280.88 (age_on Mercury input));
   "age in Venus years">:: (fun _ -> 
    let input = 189_839_836 in
    aid ~d:0.005 6.02 (age_on Earth input);
    aid ~d:0.005 9.78 (age_on Venus input));
   "age in Mars years">:: (fun _ ->
    let input = 2_329_871_239 in
    aid ~d:0.005 73.83 (age_on Earth input);
    aid ~d:0.005 39.25 (age_on Mars input));
   "age in Jupiter years">:: (fun _ ->
    let input = 901_876_382 in
    aid ~d:0.005 28.58 (age_on Earth input);
    aid ~d:0.005 2.41 (age_on Jupiter input));
   "age in Saturn years">:: (fun _ ->
    let input = 3_000_000_000 in
    aid ~d:0.005 95.06 (age_on Earth input);
    aid ~d:0.005 3.23 (age_on Saturn input));
   "age in Neptune years">:: (fun _ ->
    let input = 8_210_123_456 in
    aid ~d:0.005 260.16 (age_on Earth input);
    aid ~d:0.005 1.58 (age_on Neptune input));
   "age in Uranus years">:: (fun _ ->
    let input = 3_210_123_456 in
    aid ~d:0.005 101.72 (age_on Earth input);
    aid ~d:0.005 1.21 (age_on Uranus input))
  ]

let () =
  run_test_tt_main ("space-age tests" >::: tests)
