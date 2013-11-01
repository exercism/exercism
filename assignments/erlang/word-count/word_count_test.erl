-module(word_count_test).
-include_lib("eunit/include/eunit.hrl").

%% dict should be used to implement wound_count:count/1.

count_one_word_test() ->
    assert_count(
      "word",
      [{"word", 1}]).

count_one_of_each_test() ->
    assert_count(
      "one of each",
      [{"one", 1},
       {"of", 1},
       {"each", 1}]).

count_multiple_occurrences_test() ->
    assert_count(
      "one fish two fish red fish blue fish",
      [{"one", 1},
       {"two", 1},
       {"fish", 4},
       {"red", 1},
       {"blue", 1}]).

ignore_punctuation_test() ->
    assert_count(
      "car : carpet as java : javascript!!&@$%^&",
      [{"car", 1},
       {"carpet", 1},
       {"as", 1},
       {"java", 1},
       {"javascript", 1}]).

include_numbers_test() ->
    assert_count(
      "testing, 1, 2 testing",
      [{"testing", 2},
       {"1", 1},
       {"2", 1}]).

normalize_case_test() ->
    assert_count(
      "go Go GO",
      [{"go", 3}]).

prefix_punctuation_test() ->
    assert_count(
      "!%%#testing, 1, 2 testing",
      [{"testing", 2},
       {"1", 1},
       {"2", 1}]).

symbols_are_separators_test() ->
    assert_count(
      "hey,my_spacebar_is_broken.",
      [{"hey", 1},
       {"my", 1},
       {"spacebar", 1},
       {"is", 1},
       {"broken", 1}]).

assert_count(S, Expect) ->
    ?assertEqual(orddict:from_list(dict:to_list(word_count:count(S))),
                 orddict:from_list(Expect)).
