% To run tests:
% elc *.erl
% erl -noshell -eval "eunit:test(phone, [verbose])" -s init stop
%
-module(phone_tests).

-include_lib("eunit/include/eunit.hrl").

cleans_number_test() ->
    ?assertEqual(phone:number("(123) 456-7890"), "1234567890").

cleans_number_with_dots_test() ->
    ?assertEqual(phone:number("123.456.7890"), "1234567890").

valid_when_eleven_digits_test() ->
    ?assertEqual(phone:number("11234567890"), "1234567890").

invalid_when_eleven_digits_test() ->
    ?assertEqual(phone:number("21234567890"), "0000000000").

invalid_when_nine_digits_test() ->
    ?assertEqual(phone:number("123456789"), "0000000000").

area_code_test() ->
    ?assertEqual(phone:areacode("1234567890"), "123").

pretty_print_test() ->
    ?assertEqual(phone:pretty_print("1234567890"),  "(123) 456-7890"),
    ?assertEqual(phone:pretty_print("11234567890"), "(123) 456-7890").
