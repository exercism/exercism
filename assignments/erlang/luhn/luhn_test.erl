-module(luhn_test).
-include_lib("eunit/include/eunit.hrl").

invalid_test() ->
  ?assertNot(luhn:valid("1111")),
  ?assertNot(luhn:valid("738")).

valid_test() ->
  ?assert(luhn:valid("8739567")),
  ?assert(luhn:valid("8763")),
  ?assert(luhn:valid("2323 2005 7766 3554")).

create_test() ->
  ?assertEqual("2323 2005 7766 3554", luhn:create("2323 2005 7766 355")).
