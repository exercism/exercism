#import <XCTest/XCTest.h>
#import "RobotName.h"

@interface test_suite : XCTestCase

@end

@implementation test_suite

- (BOOL)string:(NSString *)string matches:(NSString *)regexString {

  NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:NULL];

  NSArray *matches = [expression matchesInString:string options:0 range:NSMakeRange(0,[string length])];

  return [matches count] >= 1;
}

- (void)testHasName {
  Robot *robot = [[Robot alloc] init];

  XCTAssert([self string:[robot name] matches:@"\\A\\w{2}\\d{3}\\z"]);
}

- (void)testNameSticks {
  Robot *robot = [[Robot alloc] init];
  [robot name];
  XCTAssert([[robot name] isEqualToString:[robot name]]);
}

- (void)testDifferentRobotsHaveDifferentNames {
  Robot *firstRobot = [[Robot alloc] init];
  Robot *secondRobot = [[Robot alloc] init];
  XCTAssert(![[firstRobot name] isEqualToString:[secondRobot name]]);
}

- (void)testResetName {
  Robot *robot = [[Robot alloc] init];
  NSString *firstName = [robot name];
  [robot reset];
  NSString *secondName = [robot name];

  XCTAssert(![firstName isEqualToString:secondName]);
}

@end
