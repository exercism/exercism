-module(etl_test).

-include_lib("eunit/include/eunit.hrl").

transform_one_value_test() ->
  erl_transform([{"a", [1]}], [{1, "a"}]).

transform_one_word_test() ->
  erl_transform([{"hello", ["WORLD"]}], [{"world", "hello"}]).    

transform_more_values_test() ->
    erl_transform([{"hello", ["WORLD","GSCHOOLERS"]}], [{"gschoolers", "hello"}, {"world", "hello"}]). 

transform_multiple_keys_from_one_value_test() ->
    erl_transform([{"a", [1]}, {"b", [1]}], [{1, "ab"}]).

transform_multiple_keys_from_multiple_values_test() ->
    erl_transform([{"a", [1]}, {"b", [4]}], [{1, "a"}, {4, "b"}]).

transform_more_keys_test() ->
  Old = [
    {"a", ["APPLE", "ARTICHOKE"]}
   ,{"b", ["BOAT", "BALLERINA"]}
  ],
  Expected = [
      {"apple", "a"},
      {"artichoke", "a"},
      {"ballerina", "b"},
      {"boat", "b"}
  ],
  erl_transform(Old, Expected).

transform_full_dataset_test() ->
  Old = [ 
    {1,   ["A","E","I","O","U","L","N","R","S","T"]}
  , {2,   ["D","G"]}
  , {3,   ["B","C","M","P"]}
  , {4,   ["F","H","V","W","Y"]}
  , {5,   ["K"]}
  , {8,   ["J","X"]}
  , {10,  ["Q","Z"]}
  ],
  Expected = [ 
    {"a", 1}, {"b", 3}, {"c", 3}, {"d", 2}, {"e", 1}
  , {"f", 4}, {"g", 2}, {"h", 4}, {"i", 1}, {"j", 8}
  , {"k", 5}, {"l", 1}, {"m", 3}, {"n", 1}, {"o", 1}
  , {"p", 3}, {"q", 10}, {"r", 1}, {"s", 1}, {"t", 1}
  , {"u", 1}, {"v", 4}, {"w", 4}, {"x", 8}, {"y", 4}
  , {"z", 10} 
  ],
  erl_transform(Old, Expected).

erl_transform(Old,New) ->
    ?assertEqual(example:transform(Old), New).


