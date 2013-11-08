#import <XCTest/XCTest.h>
#import "Leap.h"

@interface test_suite : XCTestCase

@end

@implementation test_suite

- (void)testVanillaLeapYear {
  Year *year = [[Year alloc] initWithCalendarYear:@1996];
  XCTAssert([year isLeapYear]);
}

- (void)testAnyOldYear {
  Year *year = [[Year alloc] initWithCalendarYear:@1997];
  XCTAssert(![year isLeapYear]);
}

- (void)testCentury {
  Year *year = [[Year alloc] initWithCalendarYear:@1900];
  XCTAssert(![year isLeapYear]);
}

- (void)testExceptionalCentury {
  Year *year = [[Year alloc] initWithCalendarYear:@2000];
  XCTAssert([year isLeapYear]);
}

@end
