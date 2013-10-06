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
#import "NavigationController.h"
#import "AwesomeUI.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
    AuthViewController *authVC = [[AuthViewController alloc] init];
    authVC.delegate = self;
    self.window.rootViewController = authVC;
    
    [self.window makeKeyAndVisible];
    
    
    [AwesomeUI setGlobalStylingTo:self.window];

    
    return YES;
}

-(void)didSuccesfullyLogin
{

    TabBarController *tabBarController = [[TabBarController alloc]init];
    //self.window.rootViewController = tabBarController;
    tabBarController.selectedIndex = 2;
    [AwesomeUI setStyleToBar:tabBarController.tabBar];
    [self.window.rootViewController presentViewController:tabBarController animated:YES completion:nil];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];

   
    
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
