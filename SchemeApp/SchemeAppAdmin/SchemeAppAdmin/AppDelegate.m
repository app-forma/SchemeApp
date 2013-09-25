//
//  AppDelegate.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/24/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "AppDelegate.h"
#import "AuthViewController.h"
#import "AdminTabBarViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    AuthViewController *authVC = [[AuthViewController alloc] init];
    authVC.delegate = self;
    self.window.rootViewController = authVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)didSuccesfullyLogin
{
    self.window.rootViewController = [[AdminTabBarViewController alloc] init];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
