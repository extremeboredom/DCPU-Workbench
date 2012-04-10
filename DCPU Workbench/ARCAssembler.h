//
//  ARCAssembler.h
//  DCPU Workbench
//
//  Created by Adam Cox on 09/04/2012.
//  Copyright (c) 2012 Adam Cox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARCAssembler : NSObject

- (BOOL)resolveValue:(NSString *)hex word0:(unsigned short *)word0 word1:(unsigned short *)word1;

- (BOOL)resolveOpCode:(NSString *)opCode toValue:(unsigned short *)value isBasic:(BOOL *)isBasic;

@end
