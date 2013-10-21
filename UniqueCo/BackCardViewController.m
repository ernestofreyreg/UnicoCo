//
//  BackCardViewController.m
//  UniqueCo
//
//  Created by Ernesto Freyre on 17/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import "BackCardViewController.h"


@interface BackCardViewController ()

@end

@implementation BackCardViewController


-(id)initWithDeckBrowser:(DeckBrowserViewController*)deckBrowser
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _deckBrowser = deckBrowser;
        
        // TAP
        UITapGestureRecognizer *gestureRecognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        [gestureRecognizerTap setNumberOfTapsRequired:2];
        [self.view addGestureRecognizer:gestureRecognizerTap];
        
    }
    return self;
}

- (void) tapHandler:(UITapGestureRecognizer *)recognizer
{
    [self dismissViewControllerAnimated:true completion:nil];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
