//
//  TopBarView.m
//  UniqueCo
//
//  Created by Ernesto Freyre on 18/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import "TopBarView.h"
#import <QuartzCore/QuartzCore.h>

@interface TopBarView()

@property NSArray *positions;

@end


@implementation TopBarView

- (id)init
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:CGRectMake(0, 0, screen.size.width, 50)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.opacity = 0.65f;
    }
    
    _positions = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(0, -100, screen.size.width, 50)],
                  [NSValue valueWithCGRect:CGRectMake(0, -50, screen.size.width, 50)],
                  [NSValue valueWithCGRect:CGRectMake(0, 0, screen.size.width, 50)],
                  nil];
    

    // Draw
    UIImageView *draw = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
    [draw setImage:[UIImage imageNamed:@"draw.png"]];
    [draw setContentMode:UIViewContentModeScaleAspectFit];
    [draw setUserInteractionEnabled:YES];
    [draw setTag:0];
    [self addSubview:draw];
    
    // Data
    UIImageView *data = [[UIImageView alloc] initWithFrame:CGRectMake(145, 10, 40, 30.5)];
    [data setImage:[UIImage imageNamed:@"data.png"]];
    [data setUserInteractionEnabled:YES];
    [data setTag:1];
    [self addSubview:data];
    
    // Decks
    UIImageView *decks = [[UIImageView alloc] initWithFrame:CGRectMake(276, 10, 30, 30)];
    [decks setImage:[UIImage imageNamed:@"decks.png"]];
    [decks setContentMode:UIViewContentModeScaleAspectFit];
    [decks setUserInteractionEnabled:YES];
    [decks setTag:2];
    [self addSubview:decks];
    
    UITapGestureRecognizer *tapGestureGive = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    UITapGestureRecognizer *tapGestureCamera = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    UITapGestureRecognizer *tapGestureTrash = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [tapGestureGive setNumberOfTapsRequired:1];
    [tapGestureCamera setNumberOfTapsRequired:1];
    [tapGestureTrash setNumberOfTapsRequired:1];
    
    [draw addGestureRecognizer:tapGestureGive];
    [data addGestureRecognizer:tapGestureCamera];
    [decks addGestureRecognizer:tapGestureTrash];
    
    return self;
}

- (void) tapGesture:(UITapGestureRecognizer *)sender
{
    UIImageView *button = (UIImageView*)sender.view;
    
    
    int tag = button.tag;
    if (tag==0) {
        NSLog(@"Draw");
    } else if (tag==1) {
        NSLog(@"Data");
    } else {
        NSLog(@"Decks");
    }
    
    
    
    
    
}

- (CGRect) getPosition:(int)position
{
    return [[_positions objectAtIndex:position+1] CGRectValue];
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
