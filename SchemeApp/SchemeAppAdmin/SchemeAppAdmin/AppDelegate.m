//
//  AppDelegate.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/24/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "AuthViewController.h"
#import "SplitViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Store fetchLocation];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    AuthViewController *authVC = [[AuthViewController alloc] init];
    authVC.delegate = self;
    self.window.rootViewController = authVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)didSuccesfullyLogin
{
    TabBarController *tabBarController = [[TabBarController alloc]init];
    self.window.rootViewController = tabBarController;
    tabBarController.selectedIndex = 0;
   
    
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
