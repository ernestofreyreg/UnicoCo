//
//  MultiDeckViewController.m
//  UniqueCo
//
//  Created by Ernesto Freyre on 13/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import "MultiDeckViewController.h"
#import "Deck.h"
#import <QuartzCore/QuartzCore.h>

@interface MultiDeckViewController ()

@property int currentDeck;
@property int totalDecks;
@property NSMutableArray * decks;
@property BOOL oneDeck;
@property CGRect lastFrame;

@end

@implementation MultiDeckViewController


//- (void)initializeDecks
//{
//    CardDeck *deck = [CardDeck create];
//    deck.name = @"My Unique Pictures";
//    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"card1.jpg"]);
//    deck.picture = imageData;
//    [deck save];
//
//}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _decks = [[NSMutableArray alloc] init];
        
        [CoreDataManager sharedManager].modelName = @"Deck";
        [CoreDataManager sharedManager].databaseName = @"Unique";
        
        NSArray *allDecks = [CardDeck all];
        if ([allDecks count]==0) {
//            [self initializeDecks];
            allDecks = [CardDeck all];
        }
        self.totalDecks = [allDecks count];
        
        for (int i=0; i<self.totalDecks; i++) {
            CardDeck *tempCardDeck = [allDecks objectAtIndex:(NSUInteger) i];
            Deck * tmpDeck = [[Deck alloc] initWithCardDeckObject:tempCardDeck intoPosition:i for:self.totalDecks];
            [_decks addObject:tmpDeck];
            [self.view addSubview:tmpDeck.cview];
        }
        
        self.currentDeck = self.totalDecks - 1;
        
        
        // UP SWIPE
        UISwipeGestureRecognizer *gestureRecognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerUp:)];
        [gestureRecognizerUp setDirection:UISwipeGestureRecognizerDirectionUp];
        [self.view addGestureRecognizer:gestureRecognizerUp];
        
        // DOWN SWIPE
        UISwipeGestureRecognizer *gestureRecognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerDown:)];
        [gestureRecognizerDown setDirection:UISwipeGestureRecognizerDirectionDown];
        [self.view addGestureRecognizer:gestureRecognizerDown];
        
        // DOUBLE TAP:
        UITapGestureRecognizer *gestureRecognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerTap:)];
        [gestureRecognizerTap setNumberOfTapsRequired:2];
        [self.view addGestureRecognizer:gestureRecognizerTap];
     
        // DOUBLE TOUCH
        UITapGestureRecognizer *gestureRecognizerTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerTap2:)];
        [gestureRecognizerTap setNumberOfTouchesRequired:2];
        [self.view addGestureRecognizer:gestureRecognizerTap2];
        
        
    }
    return self;
}



- (void) swipeHandlerUp:(UISwipeGestureRecognizer *)recognizer
{
    // SWIPE UP increments current Deck
    if (!self.oneDeck) {
        if (self.currentDeck+1<self.totalDecks) {
            NSLog(@"SWIPE UP");
            self.currentDeck ++;
            Deck * tmpDeck = [_decks objectAtIndex:(NSUInteger) self.currentDeck];
            CGRect downFrame = [tmpDeck upFrame];
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 tmpDeck.cview.frame = downFrame;
                             }
                             completion:^(BOOL finished){
                                 
                                 NSLog(@"Current Deck %i", self.currentDeck);
                             }];
        }
    }
    
    
}

- (void) swipeHandlerDown:(UISwipeGestureRecognizer *)recognizer
{
    // SWIPE UP decrements current Deck
    if (!self.oneDeck) {
        if (self.currentDeck-1>=0) {
            NSLog(@"SWIPE DOWN");
            self.currentDeck --;
            Deck * tmpDeck = [_decks objectAtIndex:(NSUInteger) (self.currentDeck + 1)];
            CGRect downFrame = [tmpDeck downFrame];
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 tmpDeck.cview.frame = downFrame;
                             }
                             completion:^(BOOL finished){
                                 NSLog(@"Current Deck %i", self.currentDeck);
                             }];
            
        }
    }
}

- (void) swipeHandlerTap2:(UITapGestureRecognizer *)recognizer
{
//    CardDeck *deck = [CardDeck create];
//    deck.name = @"Card Deck";
//    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"card2.jpg"]);
////    deck.picture = imageData;
//    [deck save];
//    NSLog(@"Added card deck");
    
}

- (void) swipeHandlerTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"Tap");
    
    if (self.oneDeck) {
        self.oneDeck = false;
        
        Deck * tmpDeck = [_decks objectAtIndex:(NSUInteger) self.currentDeck];
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             tmpDeck.cview.frame = self.lastFrame;
                             for (int i=0; i<self.totalDecks; i++) {
                                 if (i!=self.currentDeck) {
                                     Deck *tmpDeck2 = [self.decks objectAtIndex:i];
                                     tmpDeck2.cview.layer.opacity = 1.0;
                                 }
                             }
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Open Deck %i", self.currentDeck);
                         }];

    } else {
        self.oneDeck = true;
        
        Deck * tmpDeck = [_decks objectAtIndex:(NSUInteger) self.currentDeck];
        self.lastFrame = tmpDeck.cview.frame;
        
        CGRect center = [[UIScreen mainScreen] bounds];
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             tmpDeck.cview.frame = center;
                             for (int i=0; i<self.totalDecks; i++) {
                                 if (i!=self.currentDeck) {
                                     Deck *tmpDeck2 = [self.decks objectAtIndex:i];
                                     tmpDeck2.cview.layer.opacity = 0.0;
                                 }
                             }
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Open Deck %i", self.currentDeck);
                         }];
    }
    
    
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

- (void)viewDidAppear:(BOOL)animated
{
    
}

@end
