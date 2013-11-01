-module(bob).

-export([response_for/1]).

-spec response_for(string()) -> string().
response_for(String) ->
    first_match(
      String,
      [{fun is_all_spaces/1, "Fine. Be that way!"},
       {fun is_shouting/1, "Woah, chill out!"},
       {fun is_question/1, "Sure."},
       {fun (_) -> true end, "Whatever."}]).

first_match(S, [{F, Res} | Fs]) ->
    case F(S) of
        true -> Res;
        false -> first_match(S, Fs)
    end.

is_shouting(String) ->
    lists:any(fun (C) -> C >= $A andalso C =< $Z end, String) andalso
        string:to_upper(String) =:= String.

is_question(String) ->
    lists:last(String) =:= $?.

is_all_spaces(String) ->
    re:run(String, "^(\\h|\\v)*$", [unicode]) =/= nomatch.
