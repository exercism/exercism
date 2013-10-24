@interface Anagram : NSObject

- (instancetype)initWithString:(NSString *)string;
- (NSArray *)match:(NSArray *)potentialMatches;

@end


@interface Anagram ()

@property (nonatomic,strong,readwrite) NSString *baseWord;

@end

@implementation Anagram

- (instancetype)initWithString:(NSString *)string {

  self = [super init];

  if (self) {
    self.baseWord = string;
  }

  return self;
}

- (NSArray *)match:(NSArray *)potentialMatches {

  NSMutableArray *matches = [NSMutableArray array];

  [potentialMatches enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {

    if ([self isWord:self.baseWord anagramOf:obj]) {
      [matches addObject:obj];
    }

  }];

  return matches;
}

- (BOOL)isWord:(NSString *)word anagramOf:(NSString *)otherWord {

    return ![self isString:word equalToString:otherWord ignoreCase:YES] &&
      [[self sortedLettersFor:word] isEqualToArray:[self sortedLettersFor:otherWord]];

}

- (BOOL)isString:(NSString *)string equalToString:(NSString *)other ignoreCase:(BOOL)ignoreCase {
  if (ignoreCase) {
    return [[string lowercaseString] isEqualToString:[other lowercaseString]];
  } else {
    return [string isEqualToString:other];
  }
}

- (NSArray *)sortedLettersFor:(NSString *)word {
  NSArray *letters = [self letterArrayFor:[word lowercaseString]];

  NSArray *sortedLetters = [letters sortedArrayUsingComparator:^(id first, id second) {
    if (first > second) {
      return (NSComparisonResult)NSOrderedAscending;
    } else if (first < second) {
      return (NSComparisonResult)NSOrderedDescending;
    } else {
      return (NSComparisonResult)NSOrderedSame;
    }
  }];

  return sortedLetters;
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