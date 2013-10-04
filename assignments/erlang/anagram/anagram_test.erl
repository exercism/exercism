-module(anagram_test).
-include_lib("eunit/include/eunit.hrl").

find_test() ->
  ?assertEqual("inlets", anagram:find("listen", "enlists google inlets banana")).

find_not_test() ->
  ?assertEqual("", anagram:find("loosen", "enlists google inlets banana")).
