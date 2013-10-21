//
//  MultiDeckViewController.h
//  UniqueCo
//
//  Created by Ernesto Freyre on 13/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiDeckViewController : UIViewController



- (void) swipeHandlerUp:(UISwipeGestureRecognizer *)recognizer;
- (void) swipeHandlerDown:(UISwipeGestureRecognizer *)recognizer;
- (void) swipeHandlerTap:(UITapGestureRecognizer *)recognizer;


@end
