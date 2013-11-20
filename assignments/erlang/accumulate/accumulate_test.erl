-module(accumulate_test).
-import(accumulate, [accumulate/2]).
-include_lib("eunit/include/eunit.hrl").

accumulate_squares_test() ->
  Fn = fun(Number) -> Number * Number end,
  Ls = [1, 2, 3],
  ?assertEqual([1, 4, 9], accumulate:accumulate(Fn, Ls)).

accumulate_upcases_test() ->
  Fn = fun(Word) -> string:to_upper(Word) end,
  Ls = string:tokens("hello world", " "),
  ?assertEqual(["HELLO", "WORLD"], accumulate:accumulate(Fn, Ls)).

accumulate_reversed_strings_test() ->
  Fn = fun(Word) -> lists:reverse(Word) end,
  Ls = string:tokens("the quick brown fox etc", " "),
  ?assertEqual(["eht", "kciuq", "nworb", "xof", "cte"], accumulate:accumulate(Fn, Ls)).

accumulate_recursively_test() ->
  Chars = string:tokens("a b c", " "),
  Nums  = string:tokens("1 2 3", " "),
  Fn    = fun(Char) -> [Char ++ Num || Num <- Nums] end,
  ?assertEqual([["a1", "a2", "a3"], ["b1", "b2", "b3"], ["c1", "c2", "c3"]], accumulate:accumulate(Fn, Chars)).

