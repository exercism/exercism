-module(bob).

-export([response_for/1, is_question/1, is_shouting/1]).

response_for(String) ->
    case is_all_spaces(String) of
        true -> "Fine. Be that way.";
        false -> case is_shouting(String) of
                     true -> "Woah, chill out!";
                     false -> case is_question(String) of
                                  true -> "Sure.";
                                  false -> "Whatever."
                              end
                 end
    end.

is_shouting(String) ->
    string:equal(string:to_upper(String), String).

is_question(String) ->
    lists:last(String) =:= $?.

is_all_spaces(String) ->
    [] =:= string:strip(String).
