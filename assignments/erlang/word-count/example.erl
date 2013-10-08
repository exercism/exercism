-module(word_count).
-export([count/1]).



count([Char|Chars]) when is_integer(Char) ->
  count(string:tokens([Char|Chars], " "), []).



count([], Tally) when is_list(Tally) ->
  lists:flatten([io_lib:format("~s: ~B\n", [Word, Count]) || {Word, Count} <-lists:reverse(Tally)]);

count([Word|Words], []) when is_list(Word) ->
  count(Words, [{Word, 1}]);

count([Word|Words], Tally) when is_list(Word) ->
  case lists:keyfind(Word, 1, Tally) of
    {Word, Count} ->
      count(Words, lists:keyreplace(Word, 1, Tally, {Word, Count + 1}));
    false ->
      count(Words, [{Word, 1} | Tally])
  end.
