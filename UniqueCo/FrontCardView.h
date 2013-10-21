//
//  FrontCardView.h
//  UniqueCo
//
//  Created by Ernesto Freyre on 16/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface FrontCardView : UIView

@property Card* card;

- (id) initWithFrame:(CGRect)frame forCard:(Card*)card;
- (void) setAtLeft;
- (void) setAtCenter;
- (void) setAtRight;

@end
