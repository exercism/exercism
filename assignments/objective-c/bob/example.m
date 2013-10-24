#import <Foundation/Foundation.h>

@interface Bob : NSObject

- (NSString *)hey:(NSString *)statement;

@end

@implementation Bob

-(NSString *)hey:(NSString *)statement {

  NSString *response = NULL;

  if ([self isSilence:statement]) {
    response = @"Fine, be that way.";
  } else if ([self isQuestion:statement]) {
    response = @"Sure.";
  } else if ([self isShouting:statement]) {
    response = @"Woah, chill out!";
  } else {
    response = @"Whatever.";
  }

  return response;
}

-(BOOL)isSilence:(NSString *)statement {
  return [statement isEqualToString:@""];
}

-(BOOL)isQuestion:(NSString *)statement {
  return [statement hasSuffix:@"?"];
}

-(BOOL)isShouting:(NSString *)statement {
  return [statement isEqualToString:[statement uppercaseString]];
}

@end

