class DNA(object):
    thymidine = 'T'
    uracil = 'U'

    def __init__(self, strand):
        self.strand = strand

    def to_rna(self):
        return self.strand.replace(
            self.thymidine,
            self.uracil
        )
