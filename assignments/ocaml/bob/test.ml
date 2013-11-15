open Core.Std
open OUnit2
open Bob

let ae exp got _test_ctxt = assert_equal ~printer:String.to_string exp got

let tests =
  ["something">::
     ae "Whatever." (response_for "Tom-ay-to, tom-aaaah-to.");
   "shouts">::
     ae "Woah, chill out!" (response_for "WATCH OUT!");
   "questions">::
     ae "Sure." (response_for "Does this cryogenic chamber make me look fat?");
   "forceful talking">::
     ae "Whatever." (response_for "Let's go make out behind the gym!");
   "acronyms">::
     ae "Whatever." (response_for "It's ok if you don't want to go to the DMV.");
   "forceful questions">::
     ae "Woah, chill out!" (response_for "WHAT THE HELL WERE YOU THINKING?");
   "shouting with special characters">::
     ae "Woah, chill out!"
       (response_for "ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!");
   "shouting numbers">::
     ae "Woah, chill out!" (response_for "1, 2, 3, GO!");
   "statement containing question mark">::
     ae "Whatever." (response_for "Ending with ? means a question.");
   "silence">::
     ae "Fine. Be that way!" (response_for "");
   "prolonged silence">::
     ae "Fine. Be that way!" (response_for "   ");
   "non-letters with question">::
     ae "Sure." (response_for ":) ?");
   "multiple line questons">::
     ae "Whatever."
       (response_for "\nDoes this cryogenic chamber make me look fat? \nno");
   "other whitespace">::
     (* No unicode whitespace as OCaml Core doesn't seem to handle Unicode.
      * Not it seems does it see ASCII 11 (\v) as whitespace.
     *)
     ae "Fine. Be that way!" (response_for "\n\r \t");
   "only numbers">::
     ae "Whatever." (response_for "1, 2, 3");
   "question with only numbers">::
     ae "Sure." (response_for "4?");
  ]

let () =
  run_test_tt_main ("bob tests" >::: tests)
