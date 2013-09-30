//
//  AdminTabBarViewController.m
//  SchemeApp
//
//  Created by Henrik on 2013-09-17.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "TabBarSetupViewController.h"


@implementation TabBarSetupViewController
{
    UIActionSheet *signOutPopup;
}
- (id)initWithMode:(ViewMode)viewMode
{
    self = [super init];
    if (self) {        
         signOutPopup = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Sign out" otherButtonTitles:nil, nil];
        
        if (viewMode == StudentMode) {
            [self setupTabBarWithStoryboards:@[@"StudentMessagesStoryboard", @"StudentEventsStoryBoard", @"StudentWhatToReadStoryboard"]];
        } else {
            [self setupTabBarWithStoryboards:@[@"AdminEventWrapperStoryboard", @"AdminMessagesStoryboard", @"AdminUserStoryboard"]];
        }
    }
    return self;
}

- (void)setupTabBarWithStoryboards:(NSArray *)storyboards
{
    NSMutableArray *viewControllers = [NSMutableArray new];
    
    for (NSString *storyboardName in storyboards) {
        [viewControllers addObject:[[UIStoryboard storyboardWithName:storyboardName bundle:nil]instantiateInitialViewController ]];
    }
    for (UINavigationController *navController in viewControllers) {
        UIViewController *viewController = navController.topViewController;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Sign out" style:UIBarButtonItemStylePlain target:self action:@selector(didPressSignOut)];
    }
    self.viewControllers = viewControllers;
}

-(void)didPressSignOut
{
    [signOutPopup showFromTabBar:self.tabBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [self setupAdminTabBarViewController];
//    }
//    return self;
//}
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        [self setupAdminTabBarViewController];
//    }
//    return self;
//}

@end
