-module(anagram_test).
-include_lib("eunit/include/eunit.hrl").

find_test() ->
  ?assertEquals("inlets", anagram:find("listen", "enlists google inlets banana")).

find_not_test() ->
  ?assertEquals("", anagram:find("loosen", "enlists google inlets banana")).
