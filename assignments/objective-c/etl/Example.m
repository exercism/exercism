@interface ETL : NSObject

+ (NSDictionary *)transform:(NSDictionary *)original;

@end

@implementation ETL

+ (NSDictionary *)transform:(NSDictionary *)original {

  NSArray *keys = [original allKeys];
  NSMutableDictionary *transformed = [NSMutableDictionary dictionary];

  [keys enumerateObjectsUsingBlock:^(id key, NSUInteger keyIdx, BOOL *keyStop) {
    NSArray *values = [original objectForKey:key];

    [values enumerateObjectsUsingBlock:^(id value, NSUInteger valueIdx, BOOL *valueStop) {
      NSString *lowercasedString = [value lowercaseString];
      [transformed setObject:key forKey:lowercasedString];
    }];
  }];

  return transformed;
}

@end
