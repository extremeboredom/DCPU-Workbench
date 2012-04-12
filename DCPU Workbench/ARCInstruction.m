//
//  ARCInstruction.m
//  DCPU Workbench
//
//  Created by Adam Cox on 10/04/2012.
//  Copyright (c) 2012 Adam Cox. All rights reserved.
//

#import "ARCInstruction.h"
#import "ARCValue.h"

@implementation ARCInstruction
{
    NSUInteger _numberOfWords;
}

@synthesize basic = _basic;
@synthesize operation = _operation;
@synthesize valueA = _valueA;
@synthesize valueB = _valueB;

- (id)initWithBasicOperation:(unsigned short)operation 
                      valueA:(ARCValue *)valueA 
                      valueB:(ARCValue *)valueB
{
    self = [super init];
    if (self)
    {
        _basic = YES;
        _operation = operation;
        _valueA = valueA;
        _valueB = valueB;
    }
    return self;
}

- (id)initWithNonBasicOperation:(unsigned short)operation 
                         valueA:(ARCValue *)valueA 
{
    self = [super init];
    if (self)
    {
        _basic = NO;
        _operation = operation;
        _valueA = valueA;
        _valueB = nil;
    }
    return self;
}

- (NSUInteger)numberOfWords
{
    if (self.valueB == nil)
    {
        return self.valueA.numberOfWords;
    }
    else
    {
        return (self.valueA.numberOfWords + self.valueB.numberOfWords) -1;
    }
}

@end
