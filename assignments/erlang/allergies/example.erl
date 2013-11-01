-module(allergies).

-export([allergies/1, isAllergicTo/2]).

-define(ALLERGIES, ['eggs',             % 2^0
                    'peanuts',          % 2^1
                    'shellfish',        % 2^2
                    'strawberries',     % 2^3
                    'tomatoes',
                    'chocolate',
                    'pollen',
                    'cats']).



allergies(Score) ->
    lists:filter(fun (X) -> isAllergicTo(X, Score) end, ?ALLERGIES).

isAllergicTo(Allergy, Score) ->
    Index = indexOf(Allergy, ?ALLERGIES),
    case Index of
        not_found ->
            false;
        _ ->
            (Score band trunc(math:pow(2, Index))) > 0.0
    end.

indexOf(A, Allergies) ->
    index(0, Allergies, A).

index(Index, [A|_], A) ->
    Index;
index(Index, [_|Allergies], A) ->
    index(Index+1, Allergies, A);
index(_, [], _) ->
    not_found.
