-module(dna).
-export([to_rna/1]).

to_rna(Strand) ->
  lists:map(
    fun(N) ->
      case N of
        $T -> $U;
        _ -> N
      end
    end,
    Strand
  ).