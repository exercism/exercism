@interface PhoneNumber : NSObject

- (instancetype)initWithString:(NSString *)inputString;
- (NSString *)number;
- (NSString *)areaCode;

@end

@interface PhoneNumber ()

@property (nonatomic,strong,readwrite) NSString *inputString;

@end

@implementation PhoneNumber

- (instancetype)initWithString:(NSString *)inputString {
  self = [super init];
  if (self) {
    self.inputString = inputString;
  }

  return self;
}

- (NSString *)number {
  NSString *cleanNumber = [self cleanNumber];
  if ([cleanNumber length] == 10) {
    return cleanNumber;
  } else if ([cleanNumber length] == 11 && [cleanNumber hasPrefix:@"1"]) {
    return [cleanNumber substringFromIndex:1];
  } else {
    return [self defaultInvalidPhoneNumber];
  }
}

- (NSString *)cleanNumber {
  NSScanner *scanner = [NSScanner scannerWithString:self.inputString];
  NSCharacterSet *validChars = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
  NSMutableString *cleanNumber = [NSMutableString stringWithCapacity:self.inputString.length];

  while([scanner isAtEnd] == NO) {
    NSString *cleanDigit;
    if ([scanner scanCharactersFromSet:validChars intoString:&cleanDigit]) {
      [cleanNumber appendString:cleanDigit];
    } else {
      [scanner setScanLocation:([scanner scanLocation] + 1)];
    }
  }

  return cleanNumber;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"(%@) %@-%@",[self areaCode],[self prefix],[self suffix]];
}

- (NSString *)areaCode {
  return [[self number] substringWithRange:NSMakeRange(0,3)];
}

- (NSString *)prefix {
  return [[self number] substringWithRange:NSMakeRange(3,3)];
}

- (NSString *)suffix {
  return [[self number] substringWithRange:NSMakeRange(6,4)];
}

- (NSString *)defaultInvalidPhoneNumber {
  return @"0000000000";
}


@end