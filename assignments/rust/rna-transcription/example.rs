#[deriving(Eq)]
struct RibonucleicAcid {
    nucleotides: ~str
}

impl RibonucleicAcid {
    pub fn new(nucleotides: ~str) -> RibonucleicAcid { RibonucleicAcid { nucleotides: nucleotides } }
}

impl ToStr for RibonucleicAcid {
    fn to_str(&self) -> ~str {
        self.nucleotides.to_str()
    }
}

struct DeoxyribonucleicAcid {
    nucleotides: ~str
}

impl DeoxyribonucleicAcid {
    pub fn new(nucleotides: ~str) -> DeoxyribonucleicAcid { DeoxyribonucleicAcid { nucleotides: nucleotides } }

    pub fn to_rna(&self) -> RibonucleicAcid {
        let rna_nucleotides = self.nucleotides.map_chars(|chr| if chr == 'T' { 'U' } else { chr } );

        RibonucleicAcid { nucleotides: rna_nucleotides }
    }
}

