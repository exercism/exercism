open Core.Std
open OUnit2

let option_to_string f = function
  | None   -> "None"
  | Some x -> "Some " ^ f x

let ae exp got _test_ctxt =
  assert_equal ~printer:(option_to_string String.to_string) exp got

let tests =
  ["cleans number">::
     ae (Some "1234567890") (Phone.number "(123) 456-7890");
   "cleans number with dots">::
     ae (Some "1234567890") (Phone.number "123.456.7890");
   "valid when 11 digits and first is 1">::
     ae (Some "1234567890") (Phone.number "11234567890");
   "invalid when 11 digits">::
     ae None (Phone.number "21234567890");
   "invalid when 9 digits">::
     ae None (Phone.number "123456789");
   "area code">::
     ae (Some "123") (Phone.area_code "1234567890");
   "area code of invalid number">::
     ae None (Phone.area_code "1234567890123");
   "pretty print">::
     ae (Some "(123) 456-7890") (Phone.pretty "1234567890");
   "pretty print with full us phone number">::
     ae (Some "(123) 456-7890") (Phone.pretty "11234567890");
   "pretty print invalid number">::
     ae None (Phone.pretty "123456789");
  ]

let () =
  run_test_tt_main ("phone-number tests" >::: tests)
