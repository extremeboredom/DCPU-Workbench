//
//  ARCAssembler.m
//  DCPU Workbench
//
//  Created by Adam Cox on 09/04/2012.
//  Copyright (c) 2012 Adam Cox. All rights reserved.
//

#import "ARCAssembler.h"

@implementation ARCAssembler

- (unsigned short)resolveNamed:(NSString *)name
{
    if ([name isEqualToString:@"A"])
        return 0x00;
    else if ([name isEqualToString:@"B"])
        return 0x01;
    else if ([name isEqualToString:@"C"])
        return 0x02;
    else if ([name isEqualToString:@"X"])
        return 0x03;
    else if ([name isEqualToString:@"Y"])
        return 0x04;
    else if ([name isEqualToString:@"Z"])
        return 0x05;
    else if ([name isEqualToString:@"I"])
        return 0x06;
    else if ([name isEqualToString:@"J"])
        return 0x07;
    else if ([name isEqualToString:@"POP"])
        return 0x18;
    else if ([name isEqualToString:@"PEEK"])
        return 0x19;
    else if ([name isEqualToString:@"PUSH"])
        return 0x1a;
    else if ([name isEqualToString:@"SP"])
        return 0x1b;
    else if ([name isEqualToString:@"PC"])
        return 0x1c;
    else if ([name isEqualToString:@"O"])
        return 0x1d;
    
    return 0xFF;
}

- (unsigned short)resolveHex:(NSString *)hex
{
    // Parse the hex
    unsigned int value;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&value];
    if (value <= 0x1F)
    {
        value += 0x20;
    }
    else
    {
        value = 0x1F;
    }
    return (unsigned short)value;
}

- (unsigned short)resolveIndirect:(NSString *)hex
{
    unsigned short value = [self resolveNamed:[hex substringWithRange:NSMakeRange(1, 1)]];
    return value + 0x08;
}

- (unsigned short)resolveValue:(NSString *)hex
{
    NSRegularExpression *namedExp = [[NSRegularExpression alloc] initWithPattern:@"^[a-zA-Z]+$" options:NSRegularExpressionSearch error:nil];
    
    NSRegularExpression *literalExp = [[NSRegularExpression alloc] initWithPattern:@"^(0x)[0-9a-fA-F]+$" options:NSRegularExpressionSearch error:nil];
    
    NSRegularExpression *indirectNamedExp = [[NSRegularExpression alloc] initWithPattern:@"^\\[[a-zA-Z]+\\]$" options:NSRegularExpressionSearch error:nil];
    if([namedExp numberOfMatchesInString:hex options:NSMatchingCompleted range:NSMakeRange(0, [hex length])] > 0)
    {
        return [self resolveNamed:hex];
    }
    else if ([literalExp numberOfMatchesInString:hex options:NSMatchingCompleted range:NSMakeRange(0, [hex length])] > 0)
    {
        return [self resolveHex:hex];
    }
    else if ([indirectNamedExp numberOfMatchesInString:hex options:NSMatchingCompleted range:NSMakeRange(0, [hex length])] > 0)
    {
        return [self resolveIndirect:hex];
    }
    
    return 0xFF;
}

@end
