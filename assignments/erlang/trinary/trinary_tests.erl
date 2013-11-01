-module(trinary_tests).
-import(example, [toDecimal/1]).
-include_lib("eunit/include/eunit.hrl").

trinary_1_is_decimal_1_test() ->
  ?assertEqual(1, example:toDecimal("1")).

%% trinary_2_is_decimal_2_test() ->
%%   ?assertEqual(2, example:toDecimal("2")).

%% trinary_10_is_decimal_3_test() ->
%%   ?assertEqual(3, example:toDecimal("10")).

%% trinary_11_is_decimal_4_test() ->
%%   ?assertEqual(4, example:toDecimal("11")).

%% trinary_100_is_decimal_9_test() ->
%%   ?assertEqual(9, example:toDecimal("100")).

%% trinary_112_is_decimal_14_test() ->
%%   ?assertEqual(14, example:toDecimal("112")).

%% trinary_222_is_decimal_26_test() ->
%%   ?assertEqual(26, example:toDecimal("222")).

%% trinary_1120_is_decimal_42_test() ->
%%   ?assertEqual(42, example:toDecimal("1120")).

%% trinary_1122000120_is_decimal_32091_test() ->
%%   ?assertEqual(32091, example:toDecimal("1122000120")).

%% invalid_trinary_is_decimal_0_test() ->
%%   ?assertEqual(0, example:toDecimal("carrot")).

