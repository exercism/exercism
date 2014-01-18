#[deriving(Eq)]
pub struct RibonucleicAcid {
    nucleotides: ~str
}

impl RibonucleicAcid {
    pub fn new(nucleotides: ~str) -> RibonucleicAcid {
        RibonucleicAcid { nucleotides: nucleotides }
    }
}

impl ToStr for RibonucleicAcid {
    fn to_str(&self) -> ~str {
        self.nucleotides.to_str()
    }
}

pub struct DeoxyribonucleicAcid {
    nucleotides: ~str
}

fn transcribe_dna_rna(c: char) -> char {
    match c {
        'C' => 'G',
        'G' => 'C',
        'A' => 'U',
        'T' => 'A',
        _   => c
    }
}

impl DeoxyribonucleicAcid {
    pub fn new(nucleotides: ~str) -> DeoxyribonucleicAcid {
        DeoxyribonucleicAcid { nucleotides: nucleotides }
    }

    pub fn to_rna(&self) -> RibonucleicAcid {
        let rna_nucleotides = self.nucleotides.chars().map(transcribe_dna_rna).collect();
        RibonucleicAcid { nucleotides: rna_nucleotides }
    }
}

