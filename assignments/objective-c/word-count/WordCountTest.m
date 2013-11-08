#import <XCTest/XCTest.h>
#import "WordCount.h"

@interface test_suite : XCTestCase

@end

@implementation test_suite

- (void)testCountOneWord {
  WordCount *words = [[WordCount alloc] initWithString:@"word"];
  NSDictionary *expected = @{ @"word" : @1 };
  NSDictionary *result = [words count];

  XCTAssertEqual([expected objectForKey:@"word"],[result objectForKey:@"word"]);
}

- (void)testCountOneOfEeach {
  WordCount *words = [[WordCount alloc] initWithString:@"one of each"];
  NSDictionary *expected = @{ @"one" : @1, @"of" : @1, @"each" : @1 };
  NSDictionary *result = [words count];

  XCTAssertEqual([expected objectForKey:@"one"],[result objectForKey:@"one"]);
  XCTAssertEqual([expected objectForKey:@"of"],[result objectForKey:@"of"]);
  XCTAssertEqual([expected objectForKey:@"each"],[result objectForKey:@"each"]);
}

- (void)testCountMultipleOccurrences {
  WordCount *words = [[WordCount alloc] initWithString:@"one fish two fish red fish blue fish"];
  NSDictionary *expected = @{ @"one" : @1, @"fish" : @4, @"two" : @1, @"red" : @1, @"blue" : @1 };
  NSDictionary *result = [words count];

  XCTAssertEqual([expected objectForKey:@"one"],[result objectForKey:@"one"]);
  XCTAssertEqual([expected objectForKey:@"fish"],[result objectForKey:@"fish"]);
  XCTAssertEqual([expected objectForKey:@"two"],[result objectForKey:@"two"]);
  XCTAssertEqual([expected objectForKey:@"red"],[result objectForKey:@"red"]);
  XCTAssertEqual([expected objectForKey:@"blue"],[result objectForKey:@"blue"]);
}

- (void)testIgnorePunctation {
  WordCount *words = [[WordCount alloc] initWithString:@"car : carpet as java : javascript!!&@$%^&"];
  NSDictionary *expected = @{ @"car" : @1, @"carpet" : @1, @"as" : @1, @"java" : @1, @"javascript" : @1 };
  NSDictionary *result = [words count];

  XCTAssertEqual([expected objectForKey:@"car"],[result objectForKey:@"car"]);
  XCTAssertEqual([expected objectForKey:@"carpet"],[result objectForKey:@"carpet"]);
  XCTAssertEqual([expected objectForKey:@"as"],[result objectForKey:@"as"]);
  XCTAssertEqual([expected objectForKey:@"java"],[result objectForKey:@"java"]);
  XCTAssertEqual([expected objectForKey:@"javascript"],[result objectForKey:@"javascript"]);
}

- (void)includeNumbers {
  WordCount *words = [[WordCount alloc] initWithString:@"testing, 1, 2 testing"];
  NSDictionary *expected = @{ @"testing" : @2, @"1" : @1, @"2" : @1 };
  NSDictionary *result = [words count];

  XCTAssertEqual([expected objectForKey:@"testing"],[result objectForKey:@"testing"]);
  XCTAssertEqual([expected objectForKey:@"1"],[result objectForKey:@"1"]);
  XCTAssertEqual([expected objectForKey:@"2"],[result objectForKey:@"2"]);
}

- (void)normalizeCase {
  WordCount *words = [[WordCount alloc] initWithString:@"go Go GO"];
  NSDictionary *expected = @{ @"go" : @3 };
  NSDictionary *result = [words count];

  XCTAssertEqual([expected objectForKey:@"go"],[result objectForKey:@"go"]);
}

@end