-module(accumulate).
-export([accumulate/2]).

%%
%% given a fun and a list, apply fun to each list item replacing list item with fun's return value.
%%

accumulate(Fn, List)       -> accumulate(List, Fn, []).
accumulate([H|T], Fn, Out) -> accumulate(T, Fn, [Fn(H) | Out]);
accumulate([], _Fn, Out)   -> lists:reverse(Out).
