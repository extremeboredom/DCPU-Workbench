//
//  ARCAssembler.m
//  DCPU Workbench
//
//  Created by Adam Cox on 09/04/2012.
//  Copyright (c) 2012 Adam Cox. All rights reserved.
//

#import "ARCAssembler.h"

@implementation ARCAssembler

- (unsigned short)resolveRegister:(NSString *)name
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
    
    return 0xFF;
}

@end
