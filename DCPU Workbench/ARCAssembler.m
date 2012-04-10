//
//  ARCAssembler.m
//  DCPU Workbench
//
//  Created by Adam Cox on 09/04/2012.
//  Copyright (c) 2012 Adam Cox. All rights reserved.
//

#import "ARCAssembler.h"

@interface ARCAssembler ()

- (BOOL)resolveRegister:(NSString *)name word0:(unsigned short *)word0;
- (BOOL)resolveNamed:(NSString *)name word0:(unsigned short *)word0;
- (BOOL)resolveIndirect:(NSString *)hex word0:(unsigned short *)word0 word1:(unsigned short *)word1;
- (BOOL)resolveHex:(NSString *)hex word0:(unsigned short *)word0 word1:(unsigned short *)word1;
- (unsigned short)convertHex:(NSString *)hex;
- (BOOL)resolveBasicOpCode:(NSString *)opCode toValue:(unsigned short *)value;
- (BOOL)resolveExtendedOpCode:(NSString *)opCode toValue:(unsigned short *)value;

@end

@implementation ARCAssembler
{
    NSRegularExpression *registerExp;
    NSRegularExpression *namedExp;
    NSRegularExpression *literalExp;
    NSRegularExpression *indirectExp;
    NSRegularExpression *combinedExp;
    NSDictionary *opCodes;
    NSDictionary *extendedOpCodes;
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        registerExp = [[NSRegularExpression alloc] initWithPattern:@"^[A-CX-ZIJ]$" options:NSRegularExpressionAnchorsMatchLines error:nil];
        
        namedExp = [[NSRegularExpression alloc] initWithPattern:@"^[a-zA-Z]+$" options:NSRegularExpressionAnchorsMatchLines error:nil];
        
        literalExp = [[NSRegularExpression alloc] initWithPattern:@"^(0x)[0-9a-fA-F]+$" options:NSRegularExpressionAnchorsMatchLines error:nil];
        
        indirectExp = [[NSRegularExpression alloc] initWithPattern:@"^\\[([a-zA-Z]+)|(0x[0-9a-fA-F]+)|(0x[0-9a-fA-F]+\\+[a-zA-Z]+)\\]$" options:NSRegularExpressionAnchorsMatchLines error:nil];
        
        combinedExp = [[NSRegularExpression alloc] initWithPattern:@"^(0x[0-9a-fA-F]+\\+[a-zA-Z]+)$" options:NSRegularExpressionAnchorsMatchLines error:nil];
        
        opCodes = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithUnsignedShort:0x01], @"SET",
                                 [NSNumber numberWithUnsignedShort:0x02], @"ADD",
                                 [NSNumber numberWithUnsignedShort:0x03], @"SUB",
                                 [NSNumber numberWithUnsignedShort:0x04], @"MUL",
                                 [NSNumber numberWithUnsignedShort:0x05], @"DIV",
                                 [NSNumber numberWithUnsignedShort:0x06], @"MOD",
                                 [NSNumber numberWithUnsignedShort:0x07], @"SHL",
                                 [NSNumber numberWithUnsignedShort:0x08], @"SHR",
                                 [NSNumber numberWithUnsignedShort:0x09], @"AND",
                                 [NSNumber numberWithUnsignedShort:0x0A], @"BOR",
                                 [NSNumber numberWithUnsignedShort:0x0B], @"XOR",
                                 [NSNumber numberWithUnsignedShort:0x0C], @"IFE",
                                 [NSNumber numberWithUnsignedShort:0x0D], @"IFN",
                                 [NSNumber numberWithUnsignedShort:0x0E], @"IFG",
                                 [NSNumber numberWithUnsignedShort:0x0F], @"IFB",
                                 nil];
        
        extendedOpCodes = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithUnsignedShort:0x01], @"JSR",
                   nil];
    }
    return self;
}

- (BOOL)resolveRegister:(NSString *)name word0:(unsigned short *)word0
{
    if ([name isEqualToString:@"A"])
        *word0 = 0x00;
    else if ([name isEqualToString:@"B"])
        *word0 = 0x01;
    else if ([name isEqualToString:@"C"])
        *word0 = 0x02;
    else if ([name isEqualToString:@"X"])
        *word0 = 0x03;
    else if ([name isEqualToString:@"Y"])
        *word0 = 0x04;
    else if ([name isEqualToString:@"Z"])
        *word0 = 0x05;
    else if ([name isEqualToString:@"I"])
        *word0 = 0x06;
    else if ([name isEqualToString:@"J"])
        *word0 = 0x07;
    else
        return NO;
    
    return YES;
}

- (BOOL)resolveNamed:(NSString *)name word0:(unsigned short *)word0
{
    if ([name isEqualToString:@"POP"])
        *word0 = 0x18;
    else if ([name isEqualToString:@"PEEK"])
        *word0 = 0x19;
    else if ([name isEqualToString:@"PUSH"])
        *word0 = 0x1a;
    else if ([name isEqualToString:@"SP"])
        *word0 = 0x1b;
    else if ([name isEqualToString:@"PC"])
        *word0 = 0x1c;
    else if ([name isEqualToString:@"O"])
        *word0 = 0x1d;
    else 
        return NO;
    
    return YES;
}

- (BOOL)resolveHex:(NSString *)hex word0:(unsigned short *)word0 word1:(unsigned short *)word1
{
    // Parse the hex
    unsigned int value = [self convertHex:hex];
    if (value <= 0x1F)
    {
        *word0 = value + 0x20;
    }
    else
    {
        *word0 = 0x1F;
        *word1 = value;
    }
    return YES;
}

- (unsigned short)convertHex:(NSString *)hex
{
    unsigned int value;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&value];
    return (unsigned short)value;
}

- (BOOL)resolveIndirect:(NSString *)hex word0:(unsigned short *)word0 word1:(unsigned short *)word1
{
    BOOL success = NO;
    // Grab the text inside the brackets
    NSString *innerHex = [hex substringWithRange:NSMakeRange(1, [hex length] - 2)];
    // Now process each of the different types
    if ([registerExp numberOfMatchesInString:innerHex options:NSMatchingCompleted range:NSMakeRange(0, [innerHex length])])
    {
        success = [self resolveRegister:innerHex word0:word0];
        if (success)
        {
            *word0 += 0x08;
        }
    }
    else if ([literalExp numberOfMatchesInString:innerHex options:NSMatchingCompleted range:NSMakeRange(0, [innerHex length])])
    {
        *word0 = 0x1E;
        *word1 = [self convertHex:innerHex];
        success = YES;
    }
    else if ([combinedExp numberOfMatchesInString:innerHex options:NSMatchingCompleted range:NSMakeRange(0, [innerHex length])])
    {
        NSUInteger locationOfPlus = [innerHex rangeOfString:@"+"].location;
        success = [self resolveRegister:[innerHex substringFromIndex:locationOfPlus + 1] word0:word0];
        if (success)
        {
            *word0 += 0x10;
            *word1 = [self convertHex:innerHex];
        }
    }
    return success;
}

- (BOOL)resolveValue:(NSString *)hex word0:(unsigned short *)word0 word1:(unsigned short *)word1
{
    assert(word0);
    assert(word1);
    
    if ([registerExp numberOfMatchesInString:hex options:NSMatchingCompleted range:NSMakeRange(0, [hex length])])
    {
        return [self resolveRegister:hex word0:word0];
    }
    else if ([namedExp numberOfMatchesInString:hex options:NSMatchingCompleted range:NSMakeRange(0, [hex length])] > 0)
    {
        return [self resolveNamed:hex word0:word0];
    }
    else if ([literalExp numberOfMatchesInString:hex options:NSMatchingCompleted range:NSMakeRange(0, [hex length])] > 0)
    {
        return [self resolveHex:hex word0:word0 word1:word1];
    }
    else if ([indirectExp numberOfMatchesInString:hex options:NSMatchingCompleted range:NSMakeRange(0, [hex length])] > 0)
    {
        return [self resolveIndirect:hex word0:word0 word1:word1];
    }
    
    return NO;
}

- (BOOL)resolveBasicOpCode:(NSString *)opCode toValue:(unsigned short *)value
{
    NSNumber *opCodeValue = [opCodes objectForKey:opCode];
    if (opCodeValue != nil)
    {
        *value = [opCodeValue unsignedShortValue];
        return YES;
    }
    
    return NO;
}

- (BOOL)resolveExtendedOpCode:(NSString *)opCode toValue:(unsigned short *)value
{
    NSNumber *opCodeValue = [extendedOpCodes objectForKey:opCode];
    if (opCodeValue != nil)
    {
        *value = [opCodeValue unsignedShortValue];
        return YES;
    }
    
    return NO;
}

- (BOOL)resolveOpCode:(NSString *)opCode toValue:(unsigned short *)value isBasic:(BOOL *)isBasic
{
    BOOL success = NO;
    *isBasic = success = [self resolveBasicOpCode:opCode toValue:value];
    if (!success)
    {
        isBasic = NO;
        success = [self resolveExtendedOpCode:opCode toValue:value];
    }
    
    return success;
}

@end
