//
//  DeckBrowserViewController.m
//  UniqueCo
//
//  Created by Ernesto Freyre on 16/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//

#import "DeckBrowserViewController.h"
#import "Card.h"
#import "FrontCardView.h"
#import "BackCardViewController.h"
#import "TopBarView.h"


@interface DeckBrowserViewController ()

@property CardDeck *cardDeck;
@property NSMutableArray *allCards;
@property int currentCard;
@property BottomBarView *bottomPanel;
@property TopBarView *topPanel;
@property UIView *centerArea;
@property int centerAreaPosition;
@property NSArray *positions;
@property BOOL allControlsOnScreen;

@end

@implementation DeckBrowserViewController 

-(void)addSomeCards
{
    NSArray *cards = [[NSArray alloc] initWithObjects:@"CARD1     012345678901234567890123456789",@"CARD2     012345678901234567890123456789",@"CARD3     012345678901234567890123456789",@"CARD4     012345678901234567890123456789", nil];
    NSArray *images = [[NSArray alloc] initWithObjects:@"card1.jpg",@"card2.jpg",@"card3.jpg",@"card4.jpg", nil];

    for (int i=0; i<cards.count; i++) {
        NSString *cardName = [cards objectAtIndex:(NSUInteger) i];
        NSString *image = [images objectAtIndex:(NSUInteger) i];
        Card *tmp1 = [Card create];
        tmp1.uuid = cardName;
        tmp1.data = image;
        tmp1.deck = _cardDeck;
        [tmp1 save];
    }
    
}

- (void)buttonPressed:(int)action for:(UIView *)view
{
    if (action==1) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;

#if TARGET_IPHONE_SIMULATOR
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"didFinishPickingMediaWithInfo");
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    NSLog(@"Choosen image acquired");
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (id)initWithCardDeck:(id)cardDeck
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        CGRect screen = [[UIScreen mainScreen] bounds];
        
        [CoreDataManager sharedManager].modelName = @"Deck";
        [CoreDataManager sharedManager].databaseName = @"Unique";
        
        _cardDeck = cardDeck;
        NSSet *tmpAllCards = _cardDeck.cards;
        
        
        // JUST FOR TESTING
        if (tmpAllCards.count==0) {
            [self addSomeCards];
            tmpAllCards = _cardDeck.cards;
        }
        
        // MOVE CARDS FROM NSSET TO NSARRAY AND CREATE CARD VIEWS
        _allCards = [[NSMutableArray alloc] init];
        int i=0;
        for (Card *tmpCard in tmpAllCards) {
            FrontCardView *tmpCardView = [[FrontCardView alloc] initWithFrame:screen forCard:tmpCard];
            
            // Only last card is shown center, others are shown left
            if (i==tmpAllCards.count-1) {
                //[tmpCardView setAtCenterFromRight];
                //[tmpCardView setAtLeft];
            } else {
                [tmpCardView setAtLeft];
            }
            
            [_allCards addObject:tmpCardView];
            [self.view addSubview:tmpCardView];
            i++;
        }
        _currentCard = ((int)[_allCards count]) - 1;
        
        
        _topPanel = [[TopBarView alloc] init];
        [_topPanel setFrame:[_topPanel getPosition:0]];
        [self.view addSubview:_topPanel];
        
        _bottomPanel = [[BottomBarView alloc] init];
        [_bottomPanel setActionDelegate:self];
        [_bottomPanel setFrame:[_bottomPanel getPosition:0]];
        [self.view addSubview:_bottomPanel];
        

        
        
        _positions = [[NSArray alloc] initWithObjects:[NSValue valueWithCGRect:CGRectMake(0, -50, screen.size.width, screen.size.height)],
                      [NSValue valueWithCGRect:screen],
                      [NSValue valueWithCGRect:CGRectMake(0, 50, screen.size.width, screen.size.height)],
                      nil];
        
        // CENTER AREA (All gestures taken place here)
        _centerArea = [[UIView alloc] initWithFrame:screen];
        [self.view addSubview:_centerArea];
        _centerAreaPosition = 0;
        _allControlsOnScreen = NO;
        
        
        // GESTURES
        // RIGHT SWIPE
        UISwipeGestureRecognizer *gestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerRight:)];
        [gestureRecognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [_centerArea addGestureRecognizer:gestureRecognizerRight];

        // LEFT SWIPE
        UISwipeGestureRecognizer *gestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerLeft:)];
        [gestureRecognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [_centerArea addGestureRecognizer:gestureRecognizerLeft];

        // DOBLE TAP
        UITapGestureRecognizer *gestureRecognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        [gestureRecognizerTap setNumberOfTapsRequired:2];
        [_centerArea addGestureRecognizer:gestureRecognizerTap];

        // SINGLE TAP
        UITapGestureRecognizer *gestureRecognizerSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandler:)];
        [gestureRecognizerSingleTap setNumberOfTapsRequired:1];
        [_centerArea addGestureRecognizer:gestureRecognizerSingleTap];
        [gestureRecognizerSingleTap requireGestureRecognizerToFail:gestureRecognizerTap];
    
        
        // UP SWIPE
        UISwipeGestureRecognizer *gestureRecognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerUp:)];
        [gestureRecognizerUp setDirection:UISwipeGestureRecognizerDirectionUp];
        [_centerArea addGestureRecognizer:gestureRecognizerUp];
        
        // DOWN SWIPE
        UISwipeGestureRecognizer *gestureRecognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerDown:)];
        [gestureRecognizerDown setDirection:UISwipeGestureRecognizerDirectionDown];
        [_centerArea addGestureRecognizer:gestureRecognizerDown];
        
        
        
    }
    return self;
    
}

- (CGRect) getPosition:(int)position
{
    return [[_positions objectAtIndex:position+1] CGRectValue];
}

- (void) tapHandler:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"Doble Tap");
    BackCardViewController * B2 = [[BackCardViewController alloc] initWithDeckBrowser:self];
    B2.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:B2 animated:YES completion:nil];
    
}

- (void) singleTapHandler:(UITapGestureRecognizer *)recognizer
{
    if (_allControlsOnScreen==NO) {
        NSLog(@"Single Tap");
        if (_centerAreaPosition!=0) {
            if (_centerAreaPosition<0) {
                [self swipeHandlerDown:nil];
            } else if (_centerAreaPosition>0) {
                [self swipeHandlerUp:nil];
            }
        } else {
            // Brings all controls to screen at once
            [UIView animateWithDuration:.15
                                  delay:0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 CGRect screen = [[UIScreen mainScreen] bounds];
                                 [_topPanel setFrame:[_topPanel getPosition:1]];
                                 [_centerArea setFrame:CGRectMake(0, 50, screen.size.width, screen.size.height-100)];
                                 [_bottomPanel setFrame:[_bottomPanel getPosition:-1]];
                             }
                             completion:^(BOOL finished){
                                 _allControlsOnScreen = YES;
                             }];
        }
    } else {
        // Remove all controls of screen
        [UIView animateWithDuration:.15
                              delay:0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect screen = [[UIScreen mainScreen] bounds];
                             [_topPanel setFrame:[_topPanel getPosition:0]];
                             [_centerArea setFrame:screen];
                             [_bottomPanel setFrame:[_bottomPanel getPosition:0]];
                         }
                         completion:^(BOOL finished){
                             _allControlsOnScreen = NO;
                         }];

        
    }
    
}


- (void) swipeHandlerDown:(UISwipeGestureRecognizer *)recognizer
{
    if (!_allControlsOnScreen) {
        if (_centerAreaPosition<1) {
            [UIView animateWithDuration:.15
                                  delay:0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [_topPanel setFrame:[_topPanel getPosition:_centerAreaPosition+1]];
                                 [_centerArea setFrame:[self getPosition:_centerAreaPosition+1]];
                                 [_bottomPanel setFrame:[_bottomPanel getPosition:_centerAreaPosition+1]];
                             }
                             completion:^(BOOL finished){
                                 _centerAreaPosition++;
                             }];
        }
    } else {
        [self singleTapHandler:nil];
    }
}

- (void) swipeHandlerUp:(UISwipeGestureRecognizer *)recognizer
{
    if (!_allControlsOnScreen) {
        if (_centerAreaPosition>-1) {
            [UIView animateWithDuration:.15
                                  delay:0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [_topPanel setFrame:[_topPanel getPosition:_centerAreaPosition-1]];
                                 [_centerArea setFrame:[self getPosition:_centerAreaPosition-1]];
                                 [_bottomPanel setFrame:[_bottomPanel getPosition:_centerAreaPosition-1]];
                             }
                             completion:^(BOOL finished){
                                 _centerAreaPosition--;
                             }];
        }
    } else {
        [self singleTapHandler:nil];
    }
}


- (void) swipeHandlerRight:(UISwipeGestureRecognizer *)recognizer
{
    if (_currentCard>0) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             FrontCardView *goingIn = [_allCards objectAtIndex:_currentCard-1];
                             FrontCardView *goingOut = [_allCards objectAtIndex:_currentCard];

                             [goingIn setAtCenter];
                             [goingOut setAtRight];
                             
                         }
                         completion:^(BOOL finished){
                             _currentCard--;
                         }];

    }
    
}

- (void) swipeHandlerLeft:(UISwipeGestureRecognizer *)recognizer
{
    if (_currentCard<_allCards.count-1) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             FrontCardView *goingIn = [_allCards objectAtIndex:_currentCard+1];
                             FrontCardView *goingOut = [_allCards objectAtIndex:_currentCard];
                             
                             [goingIn setAtCenter];
                             [goingOut setAtLeft];
                             
                         }
                         completion:^(BOOL finished){
                             _currentCard++;
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

@end
