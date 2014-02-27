#import "BDRSACryptorKeyPair.h"//
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
#import "UIImage+Resize.h"
#include <CoreFoundation/CoreFoundation.h>
#include <Security/Security.h>
#include "NSStringAdditions.h"
#import "NSDataAdditions.h"
#import "BDRSACryptor.h"


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

- (NSData *) getRSAPublicKey;
- (void)encryptionCycleWithRSACryptor:(BDRSACryptor *)RSACryptor keyPair:(BDRSACryptorKeyPair *)RSAKeyPair error:(BDError *)error;

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
        picker.allowsEditing = NO;

#if TARGET_IPHONE_SIMULATOR
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
        
        [self presentViewController:picker animated:YES completion:NULL];
    } else if (action==0) {
        [self testMethod];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"didFinishPickingMediaWithInfo");
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];

    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    UIImage *resizedImage = [chosenImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(screenSize.width*scale, screenSize.height*scale)  interpolationQuality:kCGInterpolationHigh];

    UIImageWriteToSavedPhotosAlbum(resizedImage, nil, nil, nil);

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
    return [[_positions objectAtIndex:(NSUInteger) (position + 1)] CGRectValue];
}

- (void)testMethod {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *publicKeyFile = [NSString stringWithFormat:@"%@/public.key", documentsDirectory];
    NSString *privateKeyFile = [NSString stringWithFormat:@"%@/private.key", documentsDirectory];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:publicKeyFile] && [fileManager fileExistsAtPath:privateKeyFile]) {
        // Already created keys, load them
        BDError *error = [[BDError alloc] init];
        BDRSACryptor *cryptor = [[BDRSACryptor alloc] init];

//        NSString *privateKey = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"private" ofType:@"key"]
//                                                         encoding:NSUTF8StringEncoding
//                                                            error:nil];

        NSStringEncoding encoding;
        NSString *privateKey = [NSString stringWithContentsOfFile:privateKeyFile usedEncoding:&encoding  error:NULL];

//        NSString *publicKey = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"public" ofType:@"key"]
//                                                        encoding:NSUTF8StringEncoding
//                                                           error:nil];

        NSString *publicKey = [NSString stringWithContentsOfFile:publicKeyFile usedEncoding:&encoding error:NULL];

        BDRSACryptorKeyPair *RSAKeyPair = [[BDRSACryptorKeyPair alloc] initWithPublicKey:publicKey
                                                                              privateKey:privateKey];

        [self encryptionCycleWithRSACryptor:cryptor keyPair:RSAKeyPair error:error];




    } else {
        // Create key pair
        BDError *error = [[BDError alloc] init];
        BDRSACryptor *RSACryptor = [[BDRSACryptor alloc] init];

        BDRSACryptorKeyPair *RSAKeyPair = [RSACryptor generateKeyPairWithKeyIdentifier:@"co.getunique.user" error:error];

        [fileManager createFileAtPath:publicKeyFile contents:[RSAKeyPair.publicKey dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        [fileManager createFileAtPath:privateKeyFile contents:[RSAKeyPair.privateKey dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generated Keys"
                                                        message:@"Exported public.key and private.key to files."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }


    //    error handling...

}

- (void)encryptionCycleWithRSACryptor:(BDRSACryptor *)cryptor keyPair:(BDRSACryptorKeyPair *)RSAKeyPair error:(BDError *)error
{
    NSString *cipherText = [cryptor encrypt:@"This is a show of what we can do" key:RSAKeyPair.publicKey error:error];

    BDDebugLog(@"Cipher Text:\n%@", cipherText);

    NSString *recoveredText = [cryptor decrypt:cipherText key:RSAKeyPair.privateKey error:error];

    BDDebugLog(@"Recovered Text:\n%@", recoveredText);
}




// Helper function for ASN.1 encoding

size_t encodeLength(unsigned char * buf, size_t length) {

    // encode length in ASN.1 DER format
    if (length < 128) {
        buf[0] = length;
        return 1;
    }

    size_t i = (length / 256) + 1;
    buf[0] = i + 0x80;
    for (size_t j = 0 ; j < i; ++j) {         buf[i - j] = length & 0xFF;         length = length >> 8;
    }

    return i + 1;
}

- (NSData *) getRSAPublicKey
{

    static const unsigned char _encodedRSAEncryptionOID[15] = {

            /* Sequence of length 0xd made up of OID followed by NULL */
            0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
            0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00

    };
    static const UInt8 publicKeyIdentifier[] =  "co.getunique.user.publickey\0";


    NSData * publicTag = [NSData dataWithBytes:publicKeyIdentifier length:strlen((const char *) publicKeyIdentifier)];

    // Now lets extract the public key - build query to get bits
    NSMutableDictionary * queryPublicKey =
            [[NSMutableDictionary alloc] init];

    [queryPublicKey setObject:(__bridge id)kSecClassKey
                       forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:publicTag
                       forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA
                       forKey:(__bridge id)kSecAttrKeyType];
    [queryPublicKey setObject:[NSNumber numberWithBool:YES]
                       forKey:(__bridge id)kSecReturnData];

    NSData * publicKeyBits;
    OSStatus err = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef)&publicKeyBits);

    if (err != noErr) {
        return nil;
    }

    // OK - that gives us the "BITSTRING component of a full DER
    // encoded RSA public key - we now need to build the rest

    unsigned char builder[15];
    NSMutableData * encKey = [[NSMutableData alloc] init];
    int bitstringEncLength;

    // When we get to the bitstring - how will we encode it?
    if  ([publicKeyBits length ] + 1  < 128 )
        bitstringEncLength = 1 ;
    else
        bitstringEncLength = (([publicKeyBits length ] +1 ) / 256 ) + 2 ;

    // Overall we have a sequence of a certain length
    builder[0] = 0x30;    // ASN.1 encoding representing a SEQUENCE
    // Build up overall size made up of -
    // size of OID + size of bitstring encoding + size of actual key
    size_t i = sizeof(_encodedRSAEncryptionOID) + 2 + bitstringEncLength +
            [publicKeyBits length];
    size_t j = encodeLength(&builder[1], i);
    [encKey appendBytes:builder length:j +1];

    // First part of the sequence is the OID
    [encKey appendBytes:_encodedRSAEncryptionOID
                 length:sizeof(_encodedRSAEncryptionOID)];

    // Now add the bitstring
    builder[0] = 0x03;
    j = encodeLength(&builder[1], [publicKeyBits length] + 1);
    builder[j+1] = 0x00;
    [encKey appendBytes:builder length:j + 2];

    // Now the actual key
    [encKey appendData:publicKeyBits];

    // Now translate the result to a Base64 string
    return [NSData dataWithBytes:[encKey bytes] length:[encKey length]];
//    NSString * ret = [NSString base64StringFromData:encKey length:[encKey length]];
//    return ret;
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
    if (!_allControlsOnScreen) {
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
                             FrontCardView *goingIn = [_allCards objectAtIndex:(NSUInteger) (_currentCard - 1)];
                             FrontCardView *goingOut = [_allCards objectAtIndex:(NSUInteger) _currentCard];

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
                             FrontCardView *goingIn = [_allCards objectAtIndex:(NSUInteger) (_currentCard + 1)];
                             FrontCardView *goingOut = [_allCards objectAtIndex:(NSUInteger) _currentCard];
                             
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

}

@end
