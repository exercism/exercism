-module(word_count_test).
-include_lib("eunit/include/eunit.hrl").

count_test() ->
  compareNestedLists(word_count:count("one two two three three three"),
    "one: 1\n"
    "two: 2\n"
    "three: 3").


compareNestedLists(Response, Expected) ->
  ?assertEqual(lists:flatten(Expected), lists:flatten(Response)).

