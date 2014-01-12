-module(anagram_test).
-include_lib("eunit/include/eunit.hrl").

no_matches_test() ->
    ?assertEqual(
       anagram:find("diaper", ["hello", "world", "zombies", "pants"]),
       []).

detect_simple_anagram_test() ->
    ?assertEqual(
       anagram:find("ant", ["tan", "stand", "at"]),
       ["tan"]).

does_not_confuse_different_duplicates_test() ->
    ?assertEqual(
       anagram:find("galea", ["eagle"]),
       []).

eliminate_anagram_subsets_test() ->
    ?assertEqual(
       anagram:find("good", ["dog", "goody"]),
       []).

detect_anagram_test() ->
    ?assertEqual(
       anagram:find("listen", ["enlists", "google", "inlets", "banana"]),
       ["inlets"]).

multiple_anagrams_test() ->
    ?assertEqual(
       anagram:find("allergy", ["gallery", "ballerina", "regally", "clergy",
                                "largely", "leading"]),
       ["gallery", "regally", "largely"]).

case_insensitive_subject_test() ->
    ?assertEqual(
       anagram:find("Orchestra", ["cashregister", "carthorse", "radishes"]),
       ["carthorse"]).

case_insensitive_candidate_test() ->
    ?assertEqual(
       anagram:find("orchestra", ["cashregister", "Carthorse", "radishes"]),
       ["Carthorse"]).

does_not_detect_a_word_as_its_own_anagram_test() ->
    ?assertEqual(
       anagram:find("corn", ["corn", "dark", "Corn", "rank", "CORN", "cron", "park"]),
       ["cron"]).
