//
//  DeckBrowserViewController.h
//  UniqueCo
//
//  Created by Ernesto Freyre on 16/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardDeck.h"
#import "BottomBarView.h"

@interface DeckBrowserViewController  : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate, ThreeButtonAction>

- (id) initWithCardDeck:(CardDeck*)cardDeck;
- (void) swipeHandlerRight:(UISwipeGestureRecognizer *)recognizer;
- (void) swipeHandlerLeft:(UISwipeGestureRecognizer *)recognizer;
- (void) swipeHandlerUp:(UISwipeGestureRecognizer *)recognizer;
- (void) swipeHandlerDown:(UISwipeGestureRecognizer *)recognizer;
- (void) tapHandler:(UITapGestureRecognizer *)recognizer;
- (void) singleTapHandler:(UITapGestureRecognizer *)recognizer;
- (CGRect) getPosition:(int)position;
- (void) testMethod;

@end
