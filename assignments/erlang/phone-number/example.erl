-module(phone).

-export([number/1, areacode/1, pretty_print/1]).

-define(ZEROS, "0000000000").

number(String) ->
    Digits = digits(String),
    case length(Digits) of
        10 -> Digits;
        11 -> strip_one(Digits);
        _ -> ?ZEROS
    end.

% Strips a leading '1' off the front of a string.
strip_one([49|T]) -> T;
strip_one([_P|_T]) -> ?ZEROS.

parts(Number) ->
    PhoneNumber = number(Number),
    AreaCode = string:sub_string(PhoneNumber, 1, 3),
    Exchange = string:sub_string(PhoneNumber, 4, 6),
    Subscriber = string:sub_string(PhoneNumber, 7, 10),
    {AreaCode, Exchange, Subscriber}.

digits(String) ->
    re:replace(String, "\\D", "", [global, {return, list}]).

areacode(String) ->
    {AreaCode, _, _} = parts(String),
    AreaCode.

pretty_print(String) ->
    {AreaCode, Exchange, Subscriber} = parts(String),
    lists:flatten(io_lib:format("\(~s\) ~s-~s", [AreaCode, Exchange, Subscriber])).
