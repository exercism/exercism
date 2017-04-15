-module(grade_school).

-export([add/3, get/2, sort/1]).

-spec add(string(), integer(), dict()) -> dict().
add(Name, Grade, Students) ->
    case orddict:find(Grade, Students) of
        {ok, Class} ->
            orddict:store(Grade, lists:sort([Name | Class]), Students);
        error ->
            orddict:store(Grade, [Name], Students)
    end.

-spec get(integer(), dict()) -> [string()].
get(Grade, Students) ->
    case orddict:find(Grade, Students) of
        {ok, Class} -> Class;
        _ -> []
    end.

-spec sort(dict()) -> dict().
sort(S) ->
    S.
