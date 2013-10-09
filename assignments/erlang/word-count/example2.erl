-module(word_count).
-export([count/1]).



count(WordList) when is_list(WordList)->
  count(string:tokens(lists:flatten(WordList), " "), dict:new()).



%% Alternative shorter implementation using dict that doesn't preserve key order

count([], Tally) ->
  lists:flatten([io_lib:format("~s: ~B\n", [Word, Count]) || {Word, Count} <- dict:to_list(Tally)]);

count([Word|Words], Tally) ->
  count(Words, dict:update(Word, fun(Count) -> Count + 1 end, 1, Tally)).
