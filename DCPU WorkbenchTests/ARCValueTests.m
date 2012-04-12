//
//  ARCValueTests.m
//  DCPU Workbench
//
//  Created by Adam Cox on 10/04/2012.
//  Copyright (c) 2012 Adam Cox. All rights reserved.
//

#import "ARCValueTests.h"
#import "ARCValue.h"

@implementation ARCValueTests

- (void)testSingleWordValue
{
    unsigned short expected = 0x00;
    NSUInteger numberOfWords = 1;
    
    ARCValue *value = [[ARCValue alloc] initWithSingleWord:expected];
    
    STAssertEquals(value.numberOfWords, numberOfWords, @"Short be a single word value");
    STAssertEquals(value.firstWord, expected, @"First word should be 0x00");
}

- (void)testDoubleWordValue
{
    unsigned short expectedFirst = 0x1F;
    unsigned short expectedSecond = 0x76;
    NSUInteger numberOfWords = 2;
    
    ARCValue *value = [[ARCValue alloc] initWithFirstWord:expectedFirst secondWord:expectedSecond];
    
    STAssertEquals(value.numberOfWords, numberOfWords, @"Short be a single word value");
    STAssertEquals(value.firstWord, expectedFirst, @"First word should be 0x1F");
    STAssertEquals(value.secondWord, expectedSecond, @"Second word should be 0x76");
}

@end
