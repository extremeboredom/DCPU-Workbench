//
//  ARCAssemberTests.m
//  DCPU Workbench
//
//  Created by Adam Cox on 09/04/2012.
//  Copyright (c) 2012 Adam Cox. All rights reserved.
//

#import "ARCAssemblerTests.h"
#import "ARCAssembler.h"

@implementation ARCAssemblerTests
{
    ARCAssembler *assembler;
    unsigned short word0;
    unsigned short word1;
}

- (void)setUp
{
    assembler = [[ARCAssembler alloc] init];
    word0 = 0;
    word1 = 0;
}

- (void)tearDown
{
    assembler = nil;
}

- (void)testResolveRegisters
{
    NSDictionary *registers = [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithUnsignedShort:0x00], @"A",
     [NSNumber numberWithUnsignedShort:0x01], @"B",
     [NSNumber numberWithUnsignedShort:0x02], @"C",
     [NSNumber numberWithUnsignedShort:0x03], @"X",
     [NSNumber numberWithUnsignedShort:0x04], @"Y",
     [NSNumber numberWithUnsignedShort:0x05], @"Z",
     [NSNumber numberWithUnsignedShort:0x06], @"I",
     [NSNumber numberWithUnsignedShort:0x07], @"J",
     nil];
    
    for (NSString *reg in registers)
    {
        unsigned short expected = [[registers objectForKey:reg] unsignedShortValue];
        STAssertTrue([assembler resolveValue:reg word0:&word0 word1:&word1], @"Resolving Register %@ should be successful.", reg);
        
        STAssertEquals(word0, expected, @"Register %@ should be at 0x%02X", reg, expected);
    }
}

- (void)testResolveRegisterUnknown
{
    STAssertFalse([assembler resolveValue:@"" word0:&word0 word1:&word1], @"Resolving unknown register should fail.");
}

- (void)testResolveHex_LowEnd
{
    unsigned short expected = 0x20;
    
    STAssertTrue([assembler resolveValue:@"0x00" word0:&word0 word1:&word1], @"Literal 0x00 should resolve.");
    STAssertEquals(word0, expected, @"Literal 0x00 should be 0x20");
    
    expected = 0x30;
    STAssertTrue([assembler resolveValue:@"0x10" word0:&word0 word1:&word1], @"Literal 0x10 should resolve.");
    STAssertEquals(word0, expected, @"Literal 0x10 should be 0x30");
    
    expected = 0x3f;
    STAssertTrue([assembler resolveValue:@"0x1F" word0:&word0 word1:&word1], @"Literal 0x1F should resolve.");
    STAssertEquals(word0, expected, @"Literal 0x1F should be 0x3F");
}

- (void)testResolveHex_HighEnd
{
    unsigned short expected = 0x1F;
    unsigned short expectedWord1 = 0x20;
    STAssertTrue([assembler resolveValue:@"0x20" word0:&word0 word1:&word1], @"Literal 0x20 should resolve.");
    STAssertEquals(word0, expected, @"Literal 0x20 should be 0x1F");
    STAssertEquals(word1, expectedWord1, @"Literal 0x20 word1 should be 0x20");
    
    expectedWord1 = 0xAB;
    STAssertTrue([assembler resolveValue:@"0xAB" word0:&word0 word1:&word1], @"Literal 0xAB should resolve.");
    STAssertEquals(word0, expected, @"Literal 0xAB should be 0x1F");
    STAssertEquals(word1, expectedWord1, @"Literal 0xAB word1 should be 0xAB");
    
    expectedWord1 = 0xFFFF;
    STAssertTrue([assembler resolveValue:@"0xFFFF" word0:&word0 word1:&word1], @"Literal 0xFFFF should resolve.");
    STAssertEquals(word0, expected, @"Literal 0xFFFF should be 0x1F");
    STAssertEquals(word1, expectedWord1, @"Literal 0xFFFF word1 should be 0xFFFF");
}

- (void)testResolveStackOp
{
    NSDictionary *stackOps = [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithUnsignedShort:0x18], @"POP",
    [NSNumber numberWithUnsignedShort:0x19], @"PEEK",
    [NSNumber numberWithUnsignedShort:0x1a], @"PUSH",
    nil];
    
    for (NSString *op in stackOps)
    {
        unsigned short expected = [[stackOps objectForKey:op] unsignedShortValue];
        STAssertTrue([assembler resolveValue:op word0:&word0 word1:&word1], @"Resolving operation %@ should be successful.", op);
        
        STAssertEquals(word0, expected, @"Stack Op %@ should be at 0x%02X", op, expected);
    }
}

- (void)testResolveSpecial
{
    NSDictionary *stackOps = [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithUnsignedShort:0x1b], @"SP",
    [NSNumber numberWithUnsignedShort:0x1c], @"PC",
    [NSNumber numberWithUnsignedShort:0x1d], @"O",
    nil];
    
    
    for (NSString *op in stackOps)
    {
        unsigned short expected = [[stackOps objectForKey:op] unsignedShortValue];
        STAssertTrue([assembler resolveValue:op word0:&word0 word1:&word1], @"Resolving operation %@ should be successful.", op);
        
        STAssertEquals(word0, expected, @"Special %@ should be at 0x%02X", op, expected);
    }
}

- (void)testResolveIndirect
{
    unsigned short expected = 0x08;
    STAssertTrue([assembler resolveValue:@"[A]" word0:&word0 word1:&word1], @"[A] should resolve");
    STAssertEquals(word0, expected, @"Indirect [A] should be at 0x%02X", expected);
    
    expected = 0x0F;
    STAssertTrue([assembler resolveValue:@"[J]" word0:&word0 word1:&word1], @"[J] should resolve");
    STAssertEquals(word0, expected, @"Indirect [J] should be at 0x%02X", expected);
}

- (void)testResolveIndirectHex
{
    unsigned short expectedWord0 = 0x1E;
    unsigned short expectedWord1 = 0x00;
    
    STAssertTrue([assembler resolveValue:@"[0x00]" word0:&word0 word1:&word1], @"[0x00] should resolve.");
    STAssertEquals(word0, expectedWord0, @"Word 0 for [0x00] should be 0x1E");
    STAssertEquals(word1, expectedWord1, @"Word 1 for [0x00] should be 0x00");
    
    expectedWord1 = 0xFFFF;
    STAssertTrue([assembler resolveValue:@"[0xFFFF]" word0:&word0 word1:&word1], @"[0xFFFF] should resolve.");
    STAssertEquals(word0, expectedWord0, @"Word 0 for [0xFFFF] should be 0x1E");
    STAssertEquals(word1, expectedWord1, @"Word 1 for [0xFFFF] should be 0xFFFF");
}

- (void)testResolveIndirectHexWithRegister
{
    unsigned short expectedWord0 = 0x10;
    unsigned short expectedWord1 = 0x00;
    
    STAssertTrue([assembler resolveValue:@"[0x00+A]" word0:&word0 word1:&word1], @"[0x00+A] should resolve.");
    STAssertEquals(word0, expectedWord0, @"Word 0 for [0x00+A] should be 0x10");
    STAssertEquals(word1, expectedWord1, @"Word 1 for [0x00+A] should be 0x00");
    
    expectedWord1 = 0x604;
    STAssertTrue([assembler resolveValue:@"[0x604+A]" word0:&word0 word1:&word1], @"[0x604+A] should resolve.");
    STAssertEquals(word0, expectedWord0, @"Word 0 for [0x604+A] should be 0x10");
    STAssertEquals(word1, expectedWord1, @"Word 1 for [0x604+A] should be 0x604");
    
    expectedWord0 = 0x14;
    STAssertTrue([assembler resolveValue:@"[0x604+Y]" word0:&word0 word1:&word1], @"[0x604+Y] should resolve.");
    STAssertEquals(word0, expectedWord0, @"Word 0 for [0x604+Y] should be 0x14");
    STAssertEquals(word1, expectedWord1, @"Word 1 for [0x604+Y] should be 0x604");
}

@end
