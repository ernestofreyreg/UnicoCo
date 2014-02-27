//
//  AppDelegate.m
//  UniqueCo
//
//  Created by Ernesto Freyre on 13/10/13.
//  Copyright (c) 2013 Ernesto Freyre. All rights reserved.
//


#import "AppDelegate.h"
#import "DeckBrowserViewController.h"

@implementation AppDelegate

-(void)initializeFirstDeck
{
    CardDeck *tmp = [CardDeck create];
    tmp.name = @"My Unique Pictures";
    tmp.picture = @"first.jpg";
    [tmp save];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    // Get first Card Deck (Creating one if none exists)
    
    [CoreDataManager sharedManager].modelName = @"Deck";
    [CoreDataManager sharedManager].databaseName = @"Unique";
    NSArray *allDecks = [CardDeck all];
    if (allDecks.count==0) {
        [self initializeFirstDeck];
        allDecks = [CardDeck all];
    }
    CardDeck *firstDeck = [allDecks objectAtIndex:0];
    
    
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    DeckBrowserViewController* room = [[DeckBrowserViewController alloc] initWithCardDeck:firstDeck];
    [[self window] setRootViewController:room];
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[CoreDataManager sharedManager] saveContext];
}


@end
