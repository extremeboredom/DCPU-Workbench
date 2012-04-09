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
        unsigned short resolved = [assembler resolveRegister:reg];
        
        STAssertEquals(resolved, expected, @"Register %@ should be at 0x%02X", reg, expected);
    }
}

- (void)testResolveRegisterUnknown
{
    ARCAssembler *assembler = [[ARCAssembler alloc] init];
    unsigned short resolved = [assembler resolveRegister:@""];
    unsigned short expected = 0xFF;
    
    STAssertEquals(resolved, expected, @"Unknown Register should be at 0xFF");
}

@end
