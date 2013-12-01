open Core.Std
open OUnit2

let ae exp got = assert_equal ~printer:String.to_string exp got

let tests =
  ["a verse">:: (fun _ ->
     let exp = "8 bottles of beer on the wall, 8 bottles of beer.\nTake one down and pass it around, 7 bottles of beer on the wall.\n" in
     ae exp (Beer.verse 8));
   "verse 1">:: (fun _ ->
     let exp = "1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n" in
     ae exp (Beer.verse 1));
   "verse 2">:: (fun _ ->
     let exp = "2 bottles of beer on the wall, 2 bottles of beer.\nTake one down and pass it around, 1 bottle of beer on the wall.\n" in
     ae exp (Beer.verse 2));
   "verse 0">:: (fun _ ->
     let exp = "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n" in
     ae exp (Beer.verse 0));
   "singing several verses">:: (fun _ ->
     let exp = "8 bottles of beer on the wall, 8 bottles of beer.\nTake one down and pass it around, 7 bottles of beer on the wall.\n\n7 bottles of beer on the wall, 7 bottles of beer.\nTake one down and pass it around, 6 bottles of beer on the wall.\n\n6 bottles of beer on the wall, 6 bottles of beer.\nTake one down and pass it around, 5 bottles of beer on the wall.\n\n" in
     ae exp (Beer.sing ~from:8 ~until:6));
   "sing all the rest of the verses">:: (fun _ ->
     let exp = "3 bottles of beer on the wall, 3 bottles of beer.\nTake one down and pass it around, 2 bottles of beer on the wall.\n\n2 bottles of beer on the wall, 2 bottles of beer.\nTake one down and pass it around, 1 bottle of beer on the wall.\n\n1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n\nNo more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n\n" in
     ae exp (Beer.sing ~from:3 ~until:0))
  ]

let () =
  run_test_tt_main ("beer-song tests" >::: tests)
