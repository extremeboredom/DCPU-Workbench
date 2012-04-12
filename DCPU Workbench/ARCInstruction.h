//
//  ARCInstruction.h
//  DCPU Workbench
//
//  Created by Adam Cox on 10/04/2012.
//  Copyright (c) 2012 Adam Cox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARCValue;

@interface ARCInstruction : NSObject

- (id)initWithBasicOperation:(unsigned short)operation
                      valueA:(ARCValue *)valueA
                      valueB:(ARCValue *)valueB;

- (id)initWithNonBasicOperation:(unsigned short)operation
                         valueA:(ARCValue *)valueA;

@property (nonatomic, readonly, assign, getter=isBasic) BOOL basic;
@property (nonatomic, readonly, assign) unsigned short operation;
@property (nonatomic, readonly, strong) ARCValue *valueA;
@property (nonatomic, readonly, strong) ARCValue *valueB;

@property (nonatomic, readonly, assign) NSUInteger numberOfWords;

@end
