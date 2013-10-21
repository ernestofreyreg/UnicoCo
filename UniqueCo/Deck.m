//
//  Deck.m
//  UniqueCo
//
//  Created by Ernesto Freyre on 14/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import "Deck.h"
#import <QuartzCore/QuartzCore.h>


@implementation Deck

- (id) initWithCardDeckObject:(CardDeck*)cardDeck intoPosition:(int)position for:(int)decks;
{
    self = [super init];
    if (!self) return nil;
    
    
    self.decks = decks;
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    CGFloat peekArea = (size.height/3.0f);
    int deckHintArea = peekArea/self.decks;
    
    
    CGRect cgrect = CGRectMake(0,deckHintArea*position,size.width,size.height);
    
    self.cview = [[UIView alloc] initWithFrame:cgrect];
    self.cview.backgroundColor = [UIColor blackColor];
    [self.cview.layer setCornerRadius:9.0f];
    [self.cview.layer setMasksToBounds:YES];
    
    // Image
//    UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//    UIImage *imgFile = [UIImage imageWithData:cardDeck.picture];
//    [imageView1 setImage:imgFile];
//    [self.cview addSubview:imageView1];
    
    // Back
    UIImageView * back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 640, 316)];
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    [back setImage:backImage];
    [self.cview addSubview:back];

    // Label
    
    int fontSize = size.height/20;


    UILabel *labelCode = [ [UILabel alloc ] initWithFrame:CGRectMake(fontSize/2, fontSize/3, cgrect.size.width-(fontSize), fontSize*2)];
    labelCode.textColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    labelCode.font = [UIFont fontWithName:@"norwester" size:fontSize];
    labelCode.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    labelCode.shadowOffset = CGSizeMake(1.0f, 1.0f);

    [self.cview addSubview:labelCode];
    labelCode.text = cardDeck.name;
    
    return self;
}

- (CGRect) downFrame {
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    CGFloat peekArea = (size.height/3.0f);
    
    CGRect frame = self.cview.frame;
    frame.origin.y += (size.height-peekArea);
    
    return frame;

}

- (CGRect) upFrame {
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    CGFloat peekArea = (size.height/3.0f);
    
    CGRect frame = self.cview.frame;
    frame.origin.y -= (size.height-peekArea);
    
    return frame;
    
}


@end
