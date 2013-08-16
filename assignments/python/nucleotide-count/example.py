class DNA(object):
    nucleotides = 'ATCGU'

    def __init__(self, strand):
        self.strand = strand

    def count(self, abbreviation):
        self._validate(abbreviation)
        return self.strand.count(abbreviation)

    def nucleotide_counts(self):
        return {
            abbr: self.count(abbr)
            for abbr in 'ATGC'
        }

    def _validate(self, abbreviation):
        if abbreviation not in self.nucleotides:
            raise ValueError('%s is not a nucleotide.' % abbreviation)
