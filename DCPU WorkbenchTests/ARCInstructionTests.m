//
//  ARCInstructionTests.m
//  DCPU Workbench
//
//  Created by Adam Cox on 10/04/2012.
//  Copyright (c) 2012 Adam Cox. All rights reserved.
//

#import "ARCInstructionTests.h"
#import "ARCInstruction.h"
#import "ARCValue.h"

@implementation ARCInstructionTests

- (void)testCreateBasic
{
    unsigned short operation = 0x1;
    ARCValue *valueA = [[ARCValue alloc] initWithSingleWord:0x0];
    ARCValue *valueB = [[ARCValue alloc] initWithSingleWord:0x01];
    ARCInstruction *instruction = [[ARCInstruction alloc] initWithBasicOperation:operation valueA:valueA valueB:valueB];
    
    STAssertTrue(instruction.isBasic, @"Should be a basic operation.");
    STAssertEquals(instruction.operation, operation, @"Operation should be 0x01");
    STAssertEqualObjects(instruction.valueA, valueA, @"Value A should be 0x00");
    STAssertEqualObjects(instruction.valueB, valueB, @"Value B should be 0x01");
}

- (void)testCreateNonBasic
{
    unsigned short operation = 0x1;
    ARCValue *valueA = [[ARCValue alloc] initWithSingleWord:0x0];
    ARCInstruction *instruction = [[ARCInstruction alloc] initWithNonBasicOperation:operation valueA:valueA];
    
    STAssertFalse(instruction.isBasic, @"Should not be a basic operation.");
    STAssertEquals(instruction.operation, operation, @"Operation should be 0x01");
    STAssertEqualObjects(instruction.valueA, valueA, @"Value A should be 0x00");
    STAssertNil(instruction.valueB, @"Value B should be nil");
}

- (void)testNumberOfWordsSingle
{
    NSUInteger numWords = 1;
    ARCValue *valueA = [[ARCValue alloc] initWithSingleWord:0x0];
    ARCValue *valueB = [[ARCValue alloc] initWithSingleWord:0x01];
    ARCInstruction *instruction = [[ARCInstruction alloc] initWithBasicOperation:0x01 valueA:valueA valueB:valueB];
    
    STAssertEquals(instruction.numberOfWords, numWords, @"This instruction should be a single word.");
    
    valueA = [[ARCValue alloc] initWithSingleWord:0x0];
    instruction = [[ARCInstruction alloc] initWithNonBasicOperation:0x01 valueA:valueA];
    STAssertEquals(instruction.numberOfWords, numWords, @"This instruction should be a single word.");
}

- (void)testNumberOfWordsDouble
{
    NSUInteger numWords = 2;
    ARCValue *valueA = [[ARCValue alloc] initWithFirstWord:0x1F secondWord:0x67];
    ARCValue *valueB = [[ARCValue alloc] initWithSingleWord:0x01];
    ARCInstruction *instruction = [[ARCInstruction alloc] initWithBasicOperation:0x01 valueA:valueA valueB:valueB];
    
    STAssertEquals(instruction.numberOfWords, numWords, @"This instruction should be two words.");
    
    valueA = [[ARCValue alloc] initWithSingleWord:0x01];
    valueB = [[ARCValue alloc] initWithFirstWord:0x1F secondWord:0x67];
    instruction = [[ARCInstruction alloc] initWithBasicOperation:0x01 valueA:valueA valueB:valueB];
    
    STAssertEquals(instruction.numberOfWords, numWords, @"This instruction should be two words.");
}

- (void)testNumberOfWordsTriple
{
    NSUInteger numWords = 3;
    ARCValue *valueA = [[ARCValue alloc] initWithFirstWord:0x1F secondWord:0x67];
    ARCValue *valueB = [[ARCValue alloc] initWithFirstWord:0x1F secondWord:0xFFFF];
    ARCInstruction *instruction = [[ARCInstruction alloc] initWithBasicOperation:0x01 valueA:valueA valueB:valueB];
    
    STAssertEquals(instruction.numberOfWords, numWords, @"This instruction should be two words.");
}

@end
