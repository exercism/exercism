#import <XCTest/XCTest.h>
#import "PhoneNumber.h"

@interface test_suite : XCTestCase

@end

@implementation test_suite

- (void)testCleansNumber {
  NSString *startingNumber = @"(123) 456-7890";
  NSString *expected = @"1234567890";
  PhoneNumber *number = [[PhoneNumber alloc] initWithString:startingNumber];
  NSString *result = [number number];
  XCTAssert([result isEqualToString:expected]);
}

- (void)testCleansNumberWithDots {
  NSString *startingNumber = @"123.456.7890";
  NSString *expected = @"1234567890";
  PhoneNumber *number = [[PhoneNumber alloc] initWithString:startingNumber];
  NSString *result = [number number];
  XCTAssert([result isEqualToString:expected]);
}

- (void)testValidWithElevenDigitsAndFirstIsOne {
  NSString *startingNumber = @"11234567890";
  NSString *expected = @"1234567890";
  PhoneNumber *number = [[PhoneNumber alloc] initWithString:startingNumber];
  NSString *result = [number number];
  XCTAssert([result isEqualToString:expected]);
}

- (void)testInvalidWhenElevenDigits {
  NSString *startingNumber = @"21234567890";
  NSString *expected = @"0000000000";
  PhoneNumber *number = [[PhoneNumber alloc] initWithString:startingNumber];
  NSString *result = [number number];
  XCTAssert([result isEqualToString:expected]);
}

- (void)testInvalidWhenNineDigits {
  NSString *startingNumber = @"123456789";
  NSString *expected = @"0000000000";
  PhoneNumber *number = [[PhoneNumber alloc] initWithString:startingNumber];
  NSString *result = [number number];
  XCTAssert([result isEqualToString:expected]);
}

- (void)testAreaCode {
  NSString *startingNumber = @"1234567890";
  NSString *expected = @"123";
  PhoneNumber *number = [[PhoneNumber alloc] initWithString:startingNumber];
  NSString *result = [number areaCode];
  XCTAssert([result isEqualToString:expected]);
}

- (void)testPrettyPrint {
  NSString *startingNumber = @"1234567890";
  NSString *expected = @"(123) 456-7890";
  PhoneNumber *number = [[PhoneNumber alloc] initWithString:startingNumber];
  NSString *result = [number description];
  XCTAssert([result isEqualToString:expected]);
}

- (void)testPrettyPrintWithFullUSPhoneNumber {
  NSString *startingNumber = @"11234567890";
  NSString *expected = @"(123) 456-7890";
  PhoneNumber *number = [[PhoneNumber alloc] initWithString:startingNumber];
  NSString *result = [number description];
  XCTAssert([result isEqualToString:expected]);
}

@end