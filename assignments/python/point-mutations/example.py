class DNA(object):
    def __init__(self, strand):
        self.strand = strand

    def hamming_distance(self, other):
        return len([
            [a, b] for a, b in zip(self.strand, other)
            if a != b
        ])
