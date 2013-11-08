@interface Hamming : NSObject

+ (NSUInteger)compute:(NSString *)firstStrand against:(NSString *)secondStrand;

@end

@interface Hamming ()

@property (nonatomic,strong,readwrite) NSString *firstStrand;
@property (nonatomic,strong,readwrite) NSString *secondStrand;

@end

@implementation Hamming

+ (NSUInteger)compute:(NSString *)firstStrand against:(NSString *)secondStrand {

  Hamming *hamming = [[self alloc] initWithFirstStrand:firstStrand andSecondStrand:secondStrand];
  return [hamming distance];

}

- (instancetype)initWithFirstStrand:(NSString *)firstStrand andSecondStrand:(NSString *)secondStrand {

  self = [super init];

  if (self) {
    self.firstStrand = firstStrand;
    self.secondStrand = secondStrand;
  }

  return self;
}

- (NSUInteger)distance {
  NSUInteger calculatedDistance = 0;

  NSString *firstSequence = [self firstSequence];
  NSString *secondSequence = [self secondSequence];

  for (NSUInteger i = 0; i < [self commonDistance]; i++) {

    unichar firstGene = [firstSequence characterAtIndex:i];
    unichar secondGene = [secondSequence characterAtIndex:i];

    if ([self mutationBetween:firstGene and:secondGene]) {
        calculatedDistance ++;
    }
  }

  return calculatedDistance;
}

- (NSString *)firstSequence {
  return [self.firstStrand substringToIndex:[self commonDistance]];
}

- (NSString *)secondSequence {
  return [self.secondStrand substringToIndex:[self commonDistance]];
}

- (NSUInteger)commonDistance {
    return MIN(self.firstStrand.length,self.secondStrand.length);
}

- (BOOL)mutationBetween:(unichar)firstGene and:(unichar)secondGene {
    return (firstGene != secondGene);
}

@end