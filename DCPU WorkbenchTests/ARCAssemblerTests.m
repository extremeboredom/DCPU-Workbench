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
    
    ARCAssembler *assembler = [[ARCAssembler alloc] init];
    
    for (NSString *reg in registers)
    {
        unsigned short expected = [[registers objectForKey:reg] unsignedShortValue];
        unsigned short resolved = [assembler resolveValue:reg];
        
        STAssertEquals(resolved, expected, @"Register %@ should be at 0x%02X", reg, expected);
    }
}

- (void)testResolveRegisterUnknown
{
    ARCAssembler *assembler = [[ARCAssembler alloc] init];
    unsigned short resolved = [assembler resolveValue:@""];
    unsigned short expected = 0xFF;
    
    STAssertEquals(resolved, expected, @"Unknown Register should be at 0xFF");
}

- (void)testResolveHex_LowEnd
{
    ARCAssembler *assembler = [[ARCAssembler alloc] init];
    unsigned short expected = 0x20;
    unsigned short resolved = [assembler resolveValue:@"0x00"];
    
    STAssertEquals(resolved, expected, @"Literal 0x00 should be 0x20");
    
    expected = 0x30;
    resolved = [assembler resolveValue:@"0x10"];
    STAssertEquals(resolved, expected, @"Literal 0x10 should be 0x30");
    
    expected = 0x3f;
    resolved = [assembler resolveValue:@"0x1F"];
    STAssertEquals(resolved, expected, @"Literal 0x1F should be 0x3F");
}

- (void)testResolveHex_HighEnd
{
    ARCAssembler *assembler = [[ARCAssembler alloc] init];
    unsigned short expected = 0x1F;
    unsigned short resolved = [assembler resolveValue:@"0x20"];
    STAssertEquals(resolved, expected, @"Literal 0x20 should be 0x1F");
    
    resolved = [assembler resolveValue:@"0xAB"];
    STAssertEquals(resolved, expected, @"Literal 0xAB should be 0x1F");
    
    resolved = [assembler resolveValue:@"0xFFFF"];
    STAssertEquals(resolved, expected, @"Literal 0xFFFF should be 0x1F");
}

- (void)testResolveStackOp
{
    NSDictionary *stackOps = [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithUnsignedShort:0x18], @"POP",
    [NSNumber numberWithUnsignedShort:0x19], @"PEEK",
    [NSNumber numberWithUnsignedShort:0x1a], @"PUSH",
    nil];
    
    ARCAssembler *assembler = [[ARCAssembler alloc] init];
    
    for (NSString *op in stackOps)
    {
        unsigned short expected = [[stackOps objectForKey:op] unsignedShortValue];
        unsigned short resolved = [assembler resolveValue:op];
        
        STAssertEquals(resolved, expected, @"Stack Op %@ should be at 0x%02X", op, expected);
    }
}

- (void)testResolveSpecial
{
    NSDictionary *stackOps = [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithUnsignedShort:0x1b], @"SP",
    [NSNumber numberWithUnsignedShort:0x1c], @"PC",
    [NSNumber numberWithUnsignedShort:0x1d], @"O",
    nil];
    
    ARCAssembler *assembler = [[ARCAssembler alloc] init];
    
    for (NSString *op in stackOps)
    {
        unsigned short expected = [[stackOps objectForKey:op] unsignedShortValue];
        unsigned short resolved = [assembler resolveValue:op];
        
        STAssertEquals(resolved, expected, @"Special %@ should be at 0x%02X", op, expected);
    }
}

- (void)testResolveIndirect
{
    ARCAssembler *assembler = [[ARCAssembler alloc] init];
    unsigned short expected = 0x08;
    unsigned short resolved = [assembler resolveValue:@"[A]"];
    STAssertEquals(resolved, expected, @"Indirect [A] should be at 0x%02X", expected);
    
    expected = 0x0F;
    resolved = [assembler resolveValue:@"[J]"];
    STAssertEquals(resolved, expected, @"Indirect [J] should be at 0x%02X", expected);
}

@end
