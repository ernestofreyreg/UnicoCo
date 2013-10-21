//
//  BottomBarView.m
//  UniqueCo
//
//  Created by Ernesto Freyre on 18/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import "BottomBarView.h"
#import <QuartzCore/QuartzCore.h>

@interface BottomBarView()

@property NSArray *positions;

@end


@implementation BottomBarView 



- (id)init
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:CGRectMake(0, screen.size.height-50, screen.size.width, 50)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.opacity = 0.65f;
    }
    
    _positions = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(0, screen.size.height-50, screen.size.width, 50)],
                                                  [NSValue valueWithCGRect:CGRectMake(0, screen.size.height, screen.size.width, 50)],
                                                  [NSValue valueWithCGRect:CGRectMake(0, screen.size.height+50, screen.size.width, 50)],
                                                  nil];

    
    // Give
    UIImageView *give = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
    [give setImage:[UIImage imageNamed:@"giveaway.png"]];
    [give setContentMode:UIViewContentModeScaleAspectFit];
    [give setUserInteractionEnabled:YES];
    [give setTag:0];
    [self addSubview:give];
    
    // Camera
    UIImageView *camera = [[UIImageView alloc] initWithFrame:CGRectMake(140, 10, 40, 30.5)];
    [camera setImage:[UIImage imageNamed:@"takepicture.png"]];
    [camera setUserInteractionEnabled:YES];
    [camera setTag:1];
    [self addSubview:camera];
    
    // Trash
    UIImageView *trash = [[UIImageView alloc] initWithFrame:CGRectMake(276, 10, 30, 30)];
    [trash setImage:[UIImage imageNamed:@"trash.png"]];
    [trash setContentMode:UIViewContentModeScaleAspectFit];
    [trash setUserInteractionEnabled:YES];
    [trash setTag:2];
    [self addSubview:trash];
    
    UITapGestureRecognizer *tapGestureGive = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    UITapGestureRecognizer *tapGestureCamera = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    UITapGestureRecognizer *tapGestureTrash = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [tapGestureGive setNumberOfTapsRequired:1];
    [tapGestureCamera setNumberOfTapsRequired:1];
    [tapGestureTrash setNumberOfTapsRequired:1];
    
    [give addGestureRecognizer:tapGestureGive];
    [camera addGestureRecognizer:tapGestureCamera];
    [trash addGestureRecognizer:tapGestureTrash];
    
    return self;
}




- (CGRect) getPosition:(int)position
{
    return [[_positions objectAtIndex:position+1] CGRectValue];
}

- (void) tapGesture:(UITapGestureRecognizer *)sender
{
    UIImageView *button = (UIImageView*)sender.view;
    int tag = button.tag;
    [self executeAction:tag];
    
}

- (void)executeAction:(int)action
{
    if ([self.actionDelegate respondsToSelector:@selector(buttonPressed:for:)]) {
        [_actionDelegate buttonPressed:action for:self];
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
