#import <XCTest/XCTest.h>
#import "Hamming.h"

@interface test_suite : XCTestCase

@end

@implementation test_suite

- (void)testNoDifferenceBetweenEmptyStrands {
  NSUInteger result = [Hamming compute:@"" against:@""];
  NSUInteger expected = 0;
  XCTAssertEqual(expected,result);
}

- (void)testNoDifferenceBetweenIdenticalStrands {
  NSUInteger result = [Hamming compute:@"GGACTGA" against:@"GGACTGA"];
  NSUInteger expected = 0;
  XCTAssertEqual(expected,result);
}

- (void)testCompleteHammingDistanceInSmallStrand {
  NSUInteger result = [Hamming compute:@"ACT" against:@"GGA"];
  NSUInteger expected = 3;
  XCTAssertEqual(expected,result);
}

- (void)testHammingDistanceInOffByOneStrand {
  NSUInteger result = [Hamming compute:@"GGACGGATTCTG" against:@"AGGACGGATTCT"];
  NSUInteger expected = 9;
  XCTAssertEqual(expected,result);
}

- (void)testSmallHammingDistanceInMiddleSomewhere {
  NSUInteger result = [Hamming compute:@"GGACG" against:@"GGTCG"];
  NSUInteger expected = 1;
  XCTAssertEqual(expected,result);
}

- (void)testLargerDistance {
  NSUInteger result = [Hamming compute:@"ACCAGGG" against:@"ACTATGG"];
  NSUInteger expected = 2;
  XCTAssertEqual(expected,result);
}

- (void)testIgnoreExtraLengthOnOtherStrandWhenLonger {
  NSUInteger result = [Hamming compute:@"AAACTAGGGG" against:@"AGGCTAGCGGTAGGAC"];
  NSUInteger expected = 3;
  XCTAssertEqual(expected,result);
}

- (void)testIgnoresExtraLengthOnOriginalStrandWhenLonger {
  NSUInteger result = [Hamming compute:@"GACTACGGACAGGGTAGGGAAT" against:@"GACATCGCACACC"];
  NSUInteger expected = 5;
  XCTAssertEqual(expected,result);
}

@end