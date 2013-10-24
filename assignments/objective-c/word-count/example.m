@interface WordCount : NSObject

- (id)initWithString:(NSString *)string;
- (NSDictionary *)count;

@end


@interface WordCount ()

@property (strong,nonatomic) NSArray *words;

@end

@implementation WordCount

- (id)initWithString:(NSString *)string {

  self = [super init];

  if (self) {
    NSString *cleanString = [self stripUnwantedCharacters:[string lowercaseString]];
    [self setWords:[cleanString componentsSeparatedByString:@" "]];
  }

  return self;
}

- (NSDictionary *)count {

  NSMutableDictionary *countDictionary = [NSMutableDictionary dictionary];

  [[self words] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSNumber *count = [countDictionary objectForKey:obj];

    if (count == NULL) { count = @0; }

    [countDictionary setObject:[NSNumber numberWithInt:((int)[count integerValue] + 1)] forKey:obj];
  }];

  return countDictionary;
}

- (NSString *)stripUnwantedCharacters:(NSString *)text {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\w\\s]+" options:NSRegularExpressionCaseInsensitive error:&error];

    return [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@""];
}

@end