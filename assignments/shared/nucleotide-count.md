DNA is represented by an alphabet of the following symbols: 'A', 'C', 'G', and 'T'.

Each symbol represents a nucleotide, which is a fancy name for the particular molecules that happen to make up a large part of DNA.

Shortest intro to biochemistry EVAR:

* twigs are to birds nests as
* nucleotides are to DNA and RNA as
* amino acids are to proteins as
* sugar is to starch as
* oh crap lipids

I'm not going to talk about lipids because they're crazy complex.

So back to DNA.

Write a class `DNA` that takes a DNA string. It should have two ways of telling us how many times each nucleotide occurs in the string: `#count(nucleotide)` and `#nucleotide_count`.

```ruby
dna = DNA.new("ATGCTTCAGAAAGGTCTTACG")

dna.count('A')
# => 6

dna.count('T')
# => 6

dna.count('G')
# => 5

dna.count('C')
# => 4

dna.count('U') # Uracil is a nucleotide that is used in RNA
# => 0

dna.nucleotide_counts
# => {'A' => 6, 'T' => 6, 'G' => 5, 'C' => 4}
```

The code should raise an argument error if you try to count something that isn't a nucleotide.

```ruby
dna.count('S')
# dna.rb:23:in 'count': That's not a nucleotide, silly! (ArgumentError)
```

## Sample Dataset

```ruby
s = "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC"
dna = DNA.new(s)
dna.nucleotide_counts
# => {'A' => 20, 'T' => 21, 'G' => 17, 'C' => 12}
```
