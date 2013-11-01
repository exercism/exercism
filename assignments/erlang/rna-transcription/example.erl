-module(dna).
-export([to_rna/1]).

to_rna(Strand) ->
  lists:map(fun transcribe_to_rna/1, Strand).

transcribe_to_rna($T) ->
     $U;
transcribe_to_rna(Nucleotide) ->
    Nucleotide.
