@interface DNA : NSObject

- (instancetype)initWithStrand:(NSString *)strand;

- (NSUInteger)count:(NSString *)nucleotide;
- (NSDictionary *)nucleotideCounts;

@end


@interface DNA ()

@property (nonatomic,strong,readwrite) NSString *strand;

@end

@implementation DNA

- (instancetype)initWithStrand:(NSString *)strand {

  self = [super init];
  if (self) {

    [self validateStrand:strand];
    self.strand = strand;
  }
  return self;

}

- (NSUInteger)count:(NSString *)nucleotide {
  [self validateNucleotide:nucleotide];
  return [[[self nucleotideCounts] objectForKey:nucleotide] unsignedIntegerValue];
}

- (void)validateStrand:(NSString *)strand {
  NSRange range = [strand rangeOfCharacterFromSet:[self invalidDNANucleotides]];

  if (range.location != NSNotFound) {
    @throw [NSException exceptionWithName:@"Invalid DNA Strand" reason:@"Invalid" userInfo:@{}];
  }
}

- (NSCharacterSet *)invalidDNANucleotides {
  return [[NSCharacterSet characterSetWithCharactersInString:@"ACGT"] invertedSet];
}

- (void)validateNucleotide:(NSString *)nucleotide {
  NSRange range = [nucleotide rangeOfCharacterFromSet:[self validRNANucleotides]];

  if (range.location == NSNotFound) {
      @throw [NSException exceptionWithName:@"Invalid Nucleotide" reason:@"Invalid" userInfo:@{}];
  }
}

- (NSCharacterSet *)validRNANucleotides {
  return [NSCharacterSet characterSetWithCharactersInString:@"ATCGU"];
}

- (NSDictionary *)nucleotideCounts {

  NSArray *nucleotides = [self nucleotides];

  NSMutableDictionary *nucleotideCounts = [self baselineNucleotideCounts];

  [nucleotides enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {

    if ( ! [nucleotideCounts objectForKey:obj]) {
      [nucleotideCounts setObject:@0 forKey:obj];
    }

    NSNumber *currentCount = [nucleotideCounts objectForKey:obj];
    NSNumber *updatedCount = [NSNumber numberWithInt:([currentCount intValue] + 1)];
    [nucleotideCounts setObject:updatedCount forKey:obj];

  }];

  return nucleotideCounts;
}

- (NSArray *)nucleotides {
  return [self letterArrayFor:self.strand];
}

- (NSMutableDictionary *)baselineNucleotideCounts {
  NSMutableDictionary *nucleotideCounts = [NSMutableDictionary dictionary];

  [nucleotideCounts setObject:@0 forKey:@"A"];
  [nucleotideCounts setObject:@0 forKey:@"T"];
  [nucleotideCounts setObject:@0 forKey:@"C"];
  [nucleotideCounts setObject:@0 forKey:@"G"];

  return nucleotideCounts;
}


- (NSArray *)letterArrayFor:(NSString *)word {
  NSMutableArray *letters = [NSMutableArray array];

  for (int i = 0; i < word.length; i++) {
    unichar aCharacter = [word characterAtIndex:i];
    [letters addObject:[NSString stringWithFormat:@"%c",aCharacter]];
  }

  return letters;
}

@end