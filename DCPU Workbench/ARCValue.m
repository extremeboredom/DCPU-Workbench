//
//  ARCValue.m
//  DCPU Workbench
//
//  Created by Adam Cox on 10/04/2012.
//  Copyright (c) 2012 Adam Cox. All rights reserved.
//

#import "ARCValue.h"

@implementation ARCValue

@synthesize numberOfWords = _numberOfWords;
@synthesize firstWord = _firstWord;
@synthesize secondWord = _secondWord;

- (id)initWithSingleWord:(unsigned short)word
{
    self = [super init];
    if (self)
    {
        _numberOfWords = 1;
        _firstWord = word;
    }
    return self;
}

- (id)initWithFirstWord:(unsigned short)firstWord secondWord:(unsigned short)secondWord
{
    self = [super init];
    if (self)
    {
        _numberOfWords = 2;
        _firstWord = firstWord;
        _secondWord = secondWord;
    }
    return self;
}

@end
