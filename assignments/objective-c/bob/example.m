#import <Foundation/Foundation.h>

@interface Bob : NSObject

- (NSString *)hey:(NSString *)statement;

@end

@implementation Bob

-(NSString *)hey:(NSString *)statement {

  if ([statement isEqualToString:@""]) {
    return @"Fine, be that way.";
  } else if ([statement hasSuffix:@"?"]) {
    return @"Sure.";
  } else if ([statement isEqualToString:[statement uppercaseString]]) {
    return @"Woah, chill out!";
  } else {
    return @"Whatever.";
  }

}

@end