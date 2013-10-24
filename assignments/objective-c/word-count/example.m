#import <Foundation/Foundation.h>

@interface WordCount : NSObject

- (id)initWithString:(NSString *)string;
- (NSDictionary *)count;

@end

#import "WordCount.h"

@interface WordCount ()

@property (strong,nonatomic) NSArray *words;

@end

@implementation WordCount

- (id)initWithString:(NSString *)string {

  self = [super init];

  if (self) {
    NSString *downcasedWord = [string lowercaseString];

    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\w\\s]+" options:NSRegularExpressionCaseInsensitive error:&error];

    NSString *modifiedString = [regex stringByReplacingMatchesInString:downcasedWord  options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];

    [self setWords:[modifiedString componentsSeparatedByString:@" "]];
  }

  return self;
}

- (NSDictionary *)count {
  NSMutableDictionary *countDictionary = [NSMutableDictionary dictionary];

  [[self words] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSNumber *count = [countDictionary objectForKey:obj];

    if (count == NULL) { count = @0; }

    [countDictionary setObject:[NSNumber numberWithInt:([count integerValue] + 1)] forKey:obj];
  }];

  return countDictionary;
}

@end