#import <XCTest/XCTest.h>
#import "NucleotideCount.h"

@interface test_suite : XCTestCase

@end

@implementation test_suite

- (void)testEmptyDNAStringHasNoAdenosine {
  DNA *dna = [[DNA alloc] initWithStrand:@""];
  NSUInteger result = [dna count:@"A"];
  NSUInteger expected = 0;
  XCTAssertEqual(expected,result);
}

- (void)testEmptyDNAStringHasNoNucleotides {
  DNA *dna = [[DNA alloc] initWithStrand:@""];
  NSDictionary *results = [dna nucleotideCounts];
  NSDictionary *expected = @{ @"A": @0, @"T" : @0, @"C" : @0, @"G" : @0 };
  XCTAssert([results isEqualToDictionary:expected]);
}

- (void)testRepetitiveCytidineGetsCounted {
  DNA *dna = [[DNA alloc] initWithStrand:@"CCCCC"];
  NSUInteger result = [dna count:@"C"];
  NSUInteger expected = 5;
  XCTAssertEqual(expected,result);
}

- (void)testRepetitiveSequenceHasOnlyGuanosine {
  DNA *dna = [[DNA alloc] initWithStrand:@"GGGGGGGG"];
  NSDictionary *results = [dna nucleotideCounts];
  NSDictionary *expected = @{ @"A": @0, @"T" : @0, @"C" : @0, @"G" : @8 };
  XCTAssert([results isEqualToDictionary:expected]);
}

- (void)testCountsByThymidine {
  DNA *dna = [[DNA alloc] initWithStrand:@"GGGGGTAACCCGG"];
  NSUInteger result = [dna count:@"T"];
  NSUInteger expected = 1;
  XCTAssertEqual(expected,result);
}

- (void)testCountsANucleotideOnlyOnce {
  DNA *dna = [[DNA alloc] initWithStrand:@"CGATTGGG"];
  NSUInteger result = [dna count:@"T"];
  NSUInteger expected = 2;
  XCTAssertEqual(expected,result);
}

- (void)testDNAHasNoUracil {
  DNA *dna = [[DNA alloc] initWithStrand:@"GATTACA"];
  NSUInteger result = [dna count:@"U"];
  NSUInteger expected = 0;
  XCTAssertEqual(expected,result);
}

- (void)testDNACountsDoNoChangeAfterCountingUracil {
  DNA *dna = [[DNA alloc] initWithStrand:@"GATTACA"];
  [dna count:@"U"];
  NSDictionary *results = [dna nucleotideCounts];
  NSDictionary *expected = @{ @"A": @3, @"T" : @2, @"C" : @1, @"G" : @1 };
  XCTAssert([results isEqualToDictionary:expected]);
}

- (void)testValidatesNucleotides {
  DNA *dna = [[DNA alloc] initWithStrand:@"GACT"];
  @try {
    [dna count:@"X"];
    XCTFail(@"This is an invalid nucleotide");
  } @catch(NSException *example) { }

}

- (void)testValidatesDNANotRNA {
  @try {
    DNA *dna = [[DNA alloc] initWithStrand:@"ACGU"];
  } @catch(NSException *example) { }
}

- (void)testValidatesDNA {
  @try {
    DNA *dna = [[DNA alloc] initWithStrand:@"John"];
  } @catch(NSException *example) { }
}

- (void)testCountsAllNucleotides {
  NSString *longStrand = @"AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC";
  DNA *dna = [[DNA alloc] initWithStrand:longStrand];
  NSDictionary *results = [dna nucleotideCounts];
  NSDictionary *expected = @{ @"A": @20, @"T" : @21, @"C" : @12, @"G" : @17 };
  XCTAssert([results isEqualToDictionary:expected]);
}

@end