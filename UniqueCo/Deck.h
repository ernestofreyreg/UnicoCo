//
//  Deck.h
//  UniqueCo
//
//  Created by Ernesto Freyre on 14/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardDeck.h"

@interface Deck : NSObject


@property UIColor * color;
@property UIView * cview;
@property int decks;

- (id) initWithCardDeckObject:(CardDeck*)cardDeck intoPosition:(int)position for:(int)decks;
- (CGRect) downFrame;
- (CGRect) upFrame;

@end
