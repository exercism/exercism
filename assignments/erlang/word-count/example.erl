-module(word_count).
-export([count/1]).

-spec count(string()) -> dict().
count(S) ->
    lists:foldl(fun (K, Acc) -> dict:update_counter(K, 1, Acc) end,
                dict:new(),
                tokenize(string:to_lower(S))).

is_alnum(C) ->
    (C >= $a andalso C =< $z) orelse (C >= $0 andalso C =< $9).

is_sep(C) ->
    not is_alnum(C).

tokenize([]) ->
    [];
tokenize(S) ->
    case lists:splitwith(fun is_alnum/1, lists:dropwhile(fun is_sep/1, S)) of
        {[], Rest} ->
            tokenize(Rest);
        {Word, Rest} ->
            [Word | tokenize(Rest)]
    end.
