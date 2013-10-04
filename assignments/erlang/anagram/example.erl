-module(anagram).
-export([find/2]).


find(_, []) ->
  "";

find(Word, [Char | Chars]) when is_integer(Char) ->
  find(Word, string:tokens([Char | Chars], " "));

find(Word, [Candidate | Candidates]) when is_list(Candidate) ->
  case lists:sort(Word) == lists:sort(Candidate) of
    true -> Candidate;
    false -> find(Word, Candidates)
  end.