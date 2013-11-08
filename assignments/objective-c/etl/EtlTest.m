#import <XCTest/XCTest.h>
#import "Etl.h"

@interface test_suite : XCTestCase

@end

@implementation test_suite

- (void)testTransformOneValue {
  NSDictionary *old = @{ @1 : @[ @"WORLD" ] };
  NSDictionary *expected = @{ @"world" : @1 };

  NSDictionary *results = [ETL transform:old];

  XCTAssert([expected isEqualToDictionary:results]);
}

- (void)testTransformMoreValues {
  NSDictionary *old = @{ @1 : @[ @"WORLD", @"GSCHOOLERS" ] };
  NSDictionary *expected = @{ @"world" : @1, @"gschoolers" : @1 };

  NSDictionary *results = [ETL transform:old];

  XCTAssert([expected isEqualToDictionary:results]);
}

- (void)testMoreKeys {
  NSDictionary *old = @{ @1 : @[ @"APPLE", @"ARTICHOKE" ], @2 : @[ @"BOAT", @"BALLERINA" ] };
  NSDictionary *expected = @{ @"apple" : @1, @"artichoke" : @1, @"boat" : @2, @"ballerina" : @2 };

  NSDictionary *results = [ETL transform:old];

  XCTAssert([expected isEqualToDictionary:results]);
}

- (void)testFullDataSet {
  NSDictionary *old = @{ @1 : @[ @"A", @"E", @"I", @"O", @"U", @"L", @"N", @"R", @"S", @"T" ],
                         @2 : @[ @"D", @"G" ],
                         @3 : @[ @"B", @"C", @"M", @"P" ],
                         @4 : @[ @"F", @"H", @"V", @"W", @"Y" ],
                         @5 : @[ @"K"],
                         @8 : @[ @"J", @"X" ],
                         @10 : @[ @"Q", @"Z" ]
                       };
  NSDictionary *expected = @{ @"a" : @1, @"b" : @3, @"c" : @3, @"d" : @2, @"e" : @1,
                              @"f" : @4, @"g" : @2, @"h" : @4, @"i" : @1, @"j" : @8,
                              @"k" : @5, @"l" : @1, @"m" : @3, @"n" : @1, @"o" : @1,
                              @"p" : @3, @"q" : @10, @"r" : @1, @"s" : @1, @"t" : @1,
                              @"u" : @1, @"v" : @4, @"w" : @4, @"x" : @8, @"y" : @4,
                              @"z" : @10 };

  NSDictionary *results = [ETL transform:old];

  XCTAssert([expected isEqualToDictionary:results]);

}

@end