//
//  Card.h
//  UniqueCo
//
//  Created by Ernesto Freyre on 16/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CardDeck;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * data;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) CardDeck *deck;

@end
