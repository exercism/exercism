#import <XCTest/XCTest.h>
#import "Bob.h"

@interface test_suite : XCTestCase

@end

@implementation test_suite

- (Bob *)bob {
  return [[Bob alloc] init];
}

- (void)testStatingSomething {
  NSString *input = @"Tom-ay-to, tom-aaaah-to.";
  NSString *expected = @"Whatever.";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqual(expected,result);
}

- (void)testShouting {
  NSString *input = @"WATCH OUT!";
  NSString *expected = @"Woah, chill out!";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqual(expected,result);
}

- (void)testAskingAQuestion {
  NSString *input = @"Does this cryogenic chamber make me look fat?";
  NSString *expected = @"Sure.";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqual(expected,result);
}

- (void)testTalkingForcefully {
  NSString *input = @"Let's go make out behind the gym!";
  NSString *expected = @"Whatever.";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqual(expected,result);
}

- (void)testShoutingNumbers {
  NSString *input = @"1, 2, 3 GO!";
  NSString *expected = @"Woah, chill out!";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqual(expected,result);
}

- (void)testShoutingWithSpecialCharacters {
  NSString *input = @"ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!";
  NSString *expected = @"Woah, chill out!";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqual(expected,result);
}

- (void)testSilence {
  NSString *input = @"";
  NSString *expected = @"Fine, be that way.";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqual(expected,result);
}

@end