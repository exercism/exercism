@interface Robot : NSObject

@property (nonatomic,retain,readwrite) NSString *name;
- (void)reset;

@end

@implementation Robot

- (instancetype)init {
  self = [super init];

  if (self) {
    self.name = [self generateName];
  }

  return self;
}

- (NSString *)generateName {
  return [NSString stringWithFormat:@"%@%@%@%@%@",
    [self randomCharacter],[self randomCharacter],
    [self randomDigit],[self randomDigit],[self randomDigit]];
}

- (void)reset {
  self.name = [self generateName];
}

- (NSString *)randomCharacter {
  return [self randomObjectFromArray:[self characters]];
}

- (NSString *)randomDigit {
  return [self randomObjectFromArray:[self digits]];
}

- (NSArray *)characters {
  return @[ @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z" ];
}

- (NSArray *)digits {
  return @[ @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9" ];
}

- (NSString *)randomObjectFromArray:(NSArray *)array {
  long randomValue = random();
  unsigned long randomCharacterIndex = randomValue % [array count];

  return [array objectAtIndex:randomCharacterIndex];
}

@end