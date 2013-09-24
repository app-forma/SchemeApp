//
//  AppDelegate.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/24/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"

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
    UISplitViewController *splitVC = [UISplitViewController new];
    UIViewController *view = [UIViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:view];
    navController.navigationBar.hidden = YES;
    MenuViewController *tableViewController = [[MenuViewController alloc] init];
    splitVC.viewControllers = @[tableViewController, navController];
    self.window.rootViewController = splitVC;    
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
