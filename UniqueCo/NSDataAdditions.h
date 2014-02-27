//
// Created by Ernesto Freyre on 23/10/13.
// Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//


#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (NSDataAdditions)

+ (NSData *) base64DataFromString:(NSString *)string;

@end