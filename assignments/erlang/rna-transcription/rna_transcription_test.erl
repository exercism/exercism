-module(rna_transcription_test).
-include_lib("eunit/include/eunit.hrl").

transcribes_cytidine_unchanged_test() ->
  ?assertEqual("C", dna:to_rna("C")).

transcribes_guanosine_unchanged_test() ->
  ?assertEqual("G", dna:to_rna("G")).

transcribes_adenosine_unchanged_test() ->
  ?assertEqual("A", dna:to_rna("A")).

transcribes_thymidine_to_uracil_test() ->
  ?assertEqual("U", dna:to_rna("T")).

transcribes_all_occurences_test() ->
  ?assertEqual(
      "ACGUGGUCUUAA",
      dna:to_rna("ACGTGGTCTTAA")
  ).

