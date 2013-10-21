//
//  BottomBarView.h
//  UniqueCo
//
//  Created by Ernesto Freyre on 18/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThreeButtonAction <NSObject>

@optional
-(void)buttonPressed:(int)action for:(UIView*)view;

@end

@interface BottomBarView  : UIView

@property (weak) id <ThreeButtonAction> actionDelegate;

- (void) tapGesture:(UITapGestureRecognizer *)sender;
- (CGRect) getPosition:(int)position;
- (void) executeAction:(int)action;

@end
