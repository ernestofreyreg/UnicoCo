//
//  FrontCardView.m
//  UniqueCo
//
//  Created by Ernesto Freyre on 16/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import "FrontCardView.h"
#import <QuartzCore/QuartzCore.h>

@interface FrontCardView ()

@property UIImageView *imageView;

@end


@implementation FrontCardView

- (id)initWithFrame:(CGRect)frame forCard:(Card*)card
{
    self = [super initWithFrame:frame];
    if (self) {
        _card = card;
    
        CGSize size = [[UIScreen mainScreen] bounds].size;
        
//        int fontSize = size.height/20;

        
        self.backgroundColor = [UIColor darkGrayColor];
        [self.layer setCornerRadius:6.0f];
        [self.layer setMasksToBounds:YES];

        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        UIImage *imgFile = [UIImage imageNamed:_card.data];
        [_imageView setImage:imgFile];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        
//        UILabel *labelCode = [ [UILabel alloc ] initWithFrame:CGRectMake(fontSize/2, fontSize/3, frame.size.width-(fontSize), fontSize*2)];
//        labelCode.textColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
//        labelCode.font = [UIFont fontWithName:@"norwester" size:fontSize/3];
//        labelCode.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
//        labelCode.shadowOffset = CGSizeMake(1.0f, 1.0f);
//        labelCode.text = _card.uuid;
//        [self addSubview:labelCode];

        
    }
    return self;
}

- (void) setAtLeft
{
    CGRect center = [[UIScreen mainScreen] bounds];
    //center.origin.x = 0-center.size.width;
    self.frame = center;
    [self.layer setOpacity:0.f];
    
}

- (void) setAtCenter
{
    CGRect center = [[UIScreen mainScreen] bounds];
    self.frame = center;
    [self.layer setOpacity:1.f];
    

}


- (void) setAtRight
{
    CGRect center = [[UIScreen mainScreen] bounds];
    center.origin.x = center.size.width;
    self.frame = center;
    [self.layer setOpacity:1.f];
    
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
