//
//  CardDeck.h
//  UniqueCo
//
//  Created by Ernesto Freyre on 16/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card;

@interface CardDeck : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSSet *cards;
@end

@interface CardDeck (CoreDataGeneratedAccessors)

- (void)addCardsObject:(Card *)value;
- (void)removeCardsObject:(Card *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;

@end
