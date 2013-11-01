-module(beer_song).
-export([verse/1, sing/1, sing/2]).

bottles(0) ->
  "no more bottles";
bottles(1) ->
  "1 bottle";
bottles(N) ->
  io_lib:format("~B bottles", [N]).

-spec verse(non_neg_integer()) -> iolist().
verse(0) ->
   "No more bottles of beer on the wall, no more bottles of beer.\n"
   "Go to the store and buy some more, 99 bottles of beer on the wall.\n";
verse(N) ->
  io_lib:format(
    "~s of beer on the wall, ~s of beer.\n"
    "Take it down and pass it around, ~s of beer on the wall.\n",
    [bottles(N), bottles(N), bottles(N - 1)]).

-spec sing(non_neg_integer()) -> iolist().
sing(N) ->
  sing(N, 0).

-spec sing(non_neg_integer(), non_neg_integer()) -> iolist().
sing(From, To) ->
    lists:map(fun (N) -> [verse(N), "\n"] end, lists:seq(From, To, -1)).
