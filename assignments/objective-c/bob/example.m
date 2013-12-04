// place in Bob.h
@interface Bob : NSObject

- (NSString *)hey:(NSString *)statement;

@end

// place in Bob.m
@interface NSString (BobTalk)
-(BOOL) isEmpty;
-(BOOL) isQuestion;
-(BOOL) isShouting;
@end


@implementation Bob

-(NSString *) hey: (NSString *) input {
    if ([input isEmpty]) {
        return @"Fine, be that way.";
    }
    else if ([input isShouting]) {
        return @"Woah, chill out!";
    }
    else if ([input isQuestion]) {
        return  @"Sure.";
    }
    else {
        return @"Whatever.";
    }
}

@end

@implementation NSString (BobTalk)
-(BOOL) isEmpty {
    return  [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 1;
}
-(BOOL) isQuestion {
    return [self hasSuffix:@"?"];
}
-(BOOL) isShouting {
    return
    [self isEqualToString: [self uppercaseString]] &&
    ([self rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet] options:0].location != NSNotFound);
}

@end

