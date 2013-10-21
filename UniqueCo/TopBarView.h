//
//  TopBarView.h
//  UniqueCo
//
//  Created by Ernesto Freyre on 18/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopBarView : UIView

- (void) tapGesture:(UITapGestureRecognizer *)sender;
- (CGRect) getPosition:(int)position;

@end
