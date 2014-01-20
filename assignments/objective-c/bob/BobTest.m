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
  XCTAssertEqualObjects(expected, result, @"");
}

- (void)testShouting {
  NSString *input = @"WATCH OUT!";
  NSString *expected = @"Woah, chill out!";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}

- (void)testAskingAQuestion {
  NSString *input = @"Does this cryogenic chamber make me look fat?";
  NSString *expected = @"Sure.";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}

- (void)testTalkingForcefully {
  NSString *input = @"Let's go make out behind the gym!";
  NSString *expected = @"Whatever.";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}

- (void)testUsingAcronyms {
  NSString *input = @"It's OK if you don't want to go to the DMV.";
  NSString *expected = @"Whatever.";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}

- (void)testForcefulQuestions {
  NSString *input = @"WHAT THE HELL WERE YOU THINKING?";
  NSString *expected = @"Woah, chill out!";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}

- (void)testShoutingNumbers {
  NSString *input = @"1, 2, 3 GO!";
  NSString *expected = @"Woah, chill out!";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}

- (void)testOnlyNumbers {
  NSString *input = @"1, 2, 3.";
  NSString *expected = @"Whatever.";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}
- (void)testQuestionWithOnlyNumbers {
  NSString *input = @"4?";
  NSString *expected = @"Sure.";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}

- (void)testShoutingWithSpecialCharacters {
  NSString *input = @"ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!";
  NSString *expected = @"Woah, chill out!";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}

- (void)testShoutingWithUmlautsCharacters {
  NSString *input = @"ÄMLÄTS!";
  NSString *expected = @"Woah, chill out!";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}

- (void)testCalmlySpeakingAboutUmlauts {
  NSString *input = @"ÄMLäTS!";
  NSString *expected = @"Whatever.";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}

- (void)testShoutingWithNoExclamationMark {
  NSString *input = @"I HATE YOU";
  NSString *expected = @"Woah, chill out!";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}

- (void)testStatementContainingQuestionsMark {
  NSString *input = @"Ending with a ? means a question.";
  NSString *expected = @"Whatever.";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}

- (void)testPrattlingOn {
  NSString *input = @"Wait! Hang on.  Are you going to be OK?";
  NSString *expected = @"Sure.";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}

- (void)testSilence {
  NSString *input = @"";
  NSString *expected = @"Fine, be that way.";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}

- (void)testProlongedSilence {
  NSString *input = @"     ";
  NSString *expected = @"Fine, be that way.";
  NSString *result = [[self bob] hey:input];
  XCTAssertEqualObjects(expected, result, @"");
}

@end
