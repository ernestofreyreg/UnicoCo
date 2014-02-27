//
// Created by Ernesto Freyre on 23/10/13.
// Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//


#import <Foundation/NSString.h>

@interface NSString (NSStringAdditions)

+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;

@end
