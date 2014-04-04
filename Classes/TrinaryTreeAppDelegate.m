//
//  TrinaryTreeAppDelegate.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "TrinaryTreeAppDelegate.h"
#import "TrinaryTreeViewController.h"
#import "TestFlight.h"

@implementation TrinaryTreeAppDelegate

#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // start of your application:didFinishLaunchingWithOptions // ...
    [TestFlight takeOff:@"2245956e-fe36-4983-999b-af7f800c0f90"];
    
    // Override point for customization after application launch.
    return YES;
}

#pragma mark - Memory management
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

@end
