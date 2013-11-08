@interface Year : NSObject

- (instancetype)initWithCalendarYear:(NSNumber *)calendarYear;
- (BOOL)isLeapYear;

@end

@interface Year ()

@property (nonatomic,strong,readwrite) NSNumber *value;

@end

@implementation Year

- (instancetype)initWithCalendarYear:(NSNumber *)calendarYear {
  self = [super init];
  if (self) {
    self.value = calendarYear;
  }
  return self;
}

- (BOOL)isLeapYear {
  return ([self divisibleByFour] && ![self divisibleByHundred]) || [self divisibleByFourHundred];
}

- (int)intValue {
  return (int)[[self value] integerValue];
}

- (BOOL)divisibleByFour {
  return [self is:[self intValue] evenlyDivisibleBy:4];
}

- (BOOL)divisibleByHundred {
  return [self is:[self intValue] evenlyDivisibleBy:100];
}

- (BOOL)divisibleByFourHundred {
  return [self is:[self intValue] evenlyDivisibleBy:400];
}

- (BOOL)is:(int)numerator evenlyDivisibleBy:(int)divisor {
  return numerator % divisor == 0;
}

@end