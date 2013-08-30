-module(bob_tests).

-include_lib("eunit/include/eunit.hrl").

responds_to_something_test() ->
    bob_responds("Tom-ay-to, tom-aaaah-to.", "Whatever.").

responds_to_shouts_test() ->
    bob_responds("WATCH OUT!", "Woah, chill out!").

responds_to_questions_test() ->
    bob_responds("Does this cryogenic chamber make me look fat?", "Sure.").

responds_to_forceful_talking_test() ->
    bob_responds("Let's go make out behind the gym!", "Whatever.").

responds_to_acronyms_test() ->
    bob_responds("It's OK if you don't want to go to the DMV.", "Whatever.").

responds_to_forceful_questions_test() ->
    bob_responds("WHAT THE HELL WERE YOU THINKING?", "Woah, chill out!").

responds_to_shouting_with_special_characters_test() ->
    bob_responds("ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!", "Woah, chill out!").

responds_to_shouting_numbers_test() ->
    bob_responds("1, 2, 3, GO!", "Woah, chill out!").

responds_to_shouting_with_no_exclamation_mark_test() ->
    bob_responds("I HATE YOU", "Woah, chill out!").

responds_to_statement_containing_question_mark_test() ->
    bob_responds("Ending with ? means a question", "Whatever.").

responds_to_silence_test() ->
    bob_responds("", "Fine. Be that way.").

responds_to_prolonged_silence_test() ->
    bob_responds("    ", "Fine. Be that way.").

bob_responds(Question, Answer) ->
    ?assertEqual(bob:response_for(Question),
                  Answer).
