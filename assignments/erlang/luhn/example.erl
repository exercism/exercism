-module(luhn).
-export([valid/1, create/1, checksum/1]).



checksum(Number) ->
  checksum(
    lists:reverse(
      lists:filter(
        fun(C) ->
          ($0 =< C) andalso (C =< $9)
        end,
        Number
      )
    ),
    odd,
    0
  ).



checksum([], _, Total) ->
  Total;

checksum([H | ReversedNumber], odd, Total) ->
  checksum(ReversedNumber, even, Total + H - $0);

checksum([H | ReversedNumber], even, Total) when H < $5 ->
  checksum(ReversedNumber, odd, Total + (H - $0) * 2);

checksum([H | ReversedNumber], even, Total) when H >= $5 ->
  checksum(ReversedNumber, odd, Total + ((H - $0) * 2) - 9).



valid(Number) ->
  checksum(Number) rem 10 == 0.



create(Number) ->
  lists:flatten([Number, ($: - (checksum(Number ++ [$0]) rem 10))]).