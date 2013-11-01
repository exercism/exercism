-module(example).
-export([toDecimal/1]).
-define(BASE, 3).

%%
%% trinary/ternary (base 3) to decimal (base 10)
%%

toDecimal(StringNumeric) ->
  % numeric character list indexed by position
  IndexedList = listIndex(numericOr(StringNumeric, "")),

  % tokenize string into a list of numeric characters
  Tokens = lists:foldl(fun accumulate/2, [], IndexedList),

  % integer sum
  round(lists:sum(Tokens)).

%%
%% if string is all numeric, return it; otherwise, return given default
%%

numericOr(StringNumeric, Or) -> case re:run(StringNumeric, "^[0-9]+$") of
  {match, _} -> StringNumeric;
  nomatch    -> Or
end.

%%
%% builds a numeric character list indexed by position (i.e. [{Num, Index}, ...])
%%

listIndex(StringNumeric) ->
  {Tuples, _} = lists:mapfoldr(fun indexAccumluator/2, 0, StringNumeric), Tuples.

%%
%% Iterator to build tuples like `{Item, Index}` which correspond
%% to each item and its position in a list.
%%
%% element 1: numeric character
%% element 2: posision in the list (zero based) -- increase by one for each iteration
%%

indexAccumluator(Item, Index) -> {{Item, Index}, Index + 1}.

%%
%% accumulate list values
%%

accumulate(T, Sum) ->
  % destructure tuple into local vars
  {Digit, Index} = T,

  % cast binary into integer
  Integer = binary_to_integer(<<Digit>>),

  % append list to complete accumulation
  Sum ++ [trinary(Integer, Index)].

%%
%% trinary algorithm (apply to each numeric character)
%%

trinary(Integer, Index) -> Integer * math:pow(?BASE, Index).

