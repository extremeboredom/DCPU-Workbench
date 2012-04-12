//
//  ARCValue.h
//  DCPU Workbench
//
//  Created by Adam Cox on 10/04/2012.
//  Copyright (c) 2012 Adam Cox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARCValue : NSObject

- (id)initWithSingleWord:(unsigned short)word;
- (id)initWithFirstWord:(unsigned short)firstWord secondWord:(unsigned short)secondWord;

@property (nonatomic, assign, readonly) NSUInteger numberOfWords;
@property (nonatomic, assign, readonly) unsigned short firstWord;
@property (nonatomic, assign, readonly) unsigned short secondWord;

@end
