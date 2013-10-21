//
//  BackCardViewController.h
//  UniqueCo
//
//  Created by Ernesto Freyre on 17/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeckBrowserViewController.h"

@interface BackCardViewController : UIViewController

@property DeckBrowserViewController* deckBrowser;
- (id) initWithDeckBrowser:(DeckBrowserViewController*)deckBrowser;
- (void) tapHandler:(UITapGestureRecognizer *)recognizer;

@end
