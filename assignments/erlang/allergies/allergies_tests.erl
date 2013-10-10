% To run tests:
% elc *.erl
% erl -noshell -eval "eunit:test(allergies, [verbose])" -s init stop
%

-module(allergies_tests).

-include_lib("eunit/include/eunit.hrl").

no_allergies_at_all_test() ->
    ?assertEqual(allergies:allergies(0), []).

allergic_to_just_eggs_test() ->
    ?assertEqual(allergies:allergies(1), ['eggs']).

allergic_to_just_peanuts_test() ->
    ?assertEqual(allergies:allergies(2), ['peanuts']).

allergic_to_just_strawberries_test() ->
    ?assertEqual(allergies:allergies(8), ['strawberries']).

allergic_to_eggs_and_peanuts_test() ->
    ?assertEqual(allergies:allergies(3), ['eggs', 'peanuts']).

allergic_to_more_than_eggs_but_not_peanuts_test() ->
    ?assertEqual(allergies:allergies(5), ['eggs', 'shellfish']).

allergic_to_lots_of_stuff_test() ->
    ?assertEqual(allergies:allergies(248), ['strawberries', 'tomatoes', 'chocolate',
                                            'pollen', 'cats']).

allergic_to_everything_test() ->
    ?assertEqual(allergies:allergies(255),['eggs', 'peanuts', 'shellfish', 'strawberries',
                                           'tomatoes', 'chocolate', 'pollen', 'cats']).

no_allergies_means_not_allergic_test() ->
    ?assertNot(allergies:isAllergicTo('peanuts', 0)),
    ?assertNot(allergies:isAllergicTo('cats', 0)),
    ?assertNot(allergies:isAllergicTo('strawberries', 0)).

is_allergic_to_eggs_test() ->
    ?assert(allergies:isAllergicTo('eggs', 1)).

allergic_to_eggs_and_other_stuff_test() ->
    ?assert(allergies:isAllergicTo('eggs', 5)).

ignore_non_allergen_score_parts_test() ->
    ?assertEqual(allergies:allergies(509), ['eggs', 'shellfish', 'strawberries',
                                            'tomatoes', 'chocolate', 'pollen', 'cats']).
