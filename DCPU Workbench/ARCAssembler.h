//
//  ARCAssembler.h
//  DCPU Workbench
//
//  Created by Adam Cox on 09/04/2012.
//  Copyright (c) 2012 Adam Cox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARCAssembler : NSObject

- (unsigned short)resolveNamed:(NSString *)name;
- (unsigned short)resolveHex:(NSString *)hex;
- (unsigned short)resolveIndirect:(NSString *)hex;
- (unsigned short)resolveValue:(NSString *)hex;

@end
