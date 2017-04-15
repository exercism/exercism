% To run tests:
% elc *.erl
% erl -noshell -eval "eunit:test(grade_school), [verbose])" -s init stop
%

% use a dict with keys for each grade and a list of the students within that grade.
%  [{'grade-1', ['bill']}, {'grade-2', ['george', 'fred']]
-module(grade_school_tests).

-include_lib("eunit/include/eunit.hrl").

%% Using proplists
add_student_test() ->
    ?assertEqual(grade_school:add("Aimee", 2, []),
                 [{2, ["Aimee"]}]
                ).

add_more_students_in_same_class_test() ->
    S1 = grade_school:add("James", 2, []),
    S2 = grade_school:add("Blair", 2, S1),
    S3 = grade_school:add("Paul", 2, S2),
    ?assertEqual(S3, [{2, ["Blair","James","Paul"]}]).

add_students_to_different_grades_test() ->
    S1 = grade_school:add("Chelsea", 3, []),
    S2 = grade_school:add("Logan", 7, S1),
    ?assertEqual(S2, [{3, ["Chelsea"]}, {7, ["Logan"]}]).

get_students_in_a_grade_test() ->
    S1 = grade_school:add("Franklin", 5, []),
    S2 = grade_school:add("Bradley", 5, S1),
    S3 = grade_school:add("Jeff", 1, S2),
    ?assertEqual(grade_school:get(5, S3), ["Bradley","Franklin"]).

get_students_in_a_non_existant_grade_test() ->
    ?assertEqual([], grade_school:get(1, [])).

sort_school_test() ->
    S1 = grade_school:add("Jennifer", 4, []),
    S2 = grade_school:add("Kareem", 6, S1),
    S3 = grade_school:add("Christopher", 4, S2),
    S4 = grade_school:add("Kyle", 3, S3),

    Sorted = [{3, ["Kyle"]},
              {4, ["Christopher", "Jennifer"]},
              {6, ["Kareem"]}],

    ?assertEqual(Sorted, grade_school:sort(S4)).
