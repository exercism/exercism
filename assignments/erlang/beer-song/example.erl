-module(beer_song).
-export([verse/1, sing/1, sing/2]).



nBottles(0) ->
  "no more bottles";

nBottles(1) ->
  "1 bottle";

nBottles(N) ->
  io_lib:format("~B bottles", [N]).



verse(0) ->
   "No more bottles of beer on the wall, no more bottles of beer.\n"
   "Go to the store and buy some more, 99 bottles of beer on the wall.\n";

verse(N) ->
  io_lib:format(
    "~s of beer on the wall, ~s of beer.\n"
    "Take it down and pass it around, ~s of beer on the wall.\n",
    [nBottles(N), nBottles(N), nBottles(N - 1)]).



sing(N) ->
  sing(N, 0).



sing(N, N) ->
  verse(N);

sing(N, M) ->
  io_lib:format("~s\n~s", [verse(N), sing(N-1, M)]).



