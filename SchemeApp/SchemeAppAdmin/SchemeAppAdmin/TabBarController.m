//
//  tabBarViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "TabBarController.h"
#import "MasterEventWrapperViewController.h"
#import "DetailEventWrapperViewController.h"
#import "MasterMessageViewController.h"
#import "DetailMessageViewController.h"
#import "MasterUserViewController.h"
#import "DetailUserViewController.h"
#import "SplitViewController.h"
#import "SchoolInfoViewController.h"
#import "AwesomeUI.h"


@interface TabBarController ()<UITabBarControllerDelegate, UISplitViewControllerDelegate>
{
    MasterEventWrapperViewController *mevc;
    DetailEventWrapperViewController *devc;
    MasterMessageViewController *mmvc;
    DetailMessageViewController *dmvc;
    MasterUserViewController *muvc;
    DetailUserViewController *duvc;
    SplitViewController *eventWrapperSplitView;
    SplitViewController *usersSplitView;
    SplitViewController *messagesSplitView;
    UIBarButtonItem *barButtonForMaster;
}
@end

@implementation TabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)init{
    self = [super init];
    if (self)
    {

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width + 260, self.tabBar.frame.size.height)];
        view.backgroundColor = [AwesomeUI barColor];
        [view setAlpha:0.5];
        [self.tabBar addSubview:view];
        
        
        self.delegate = self;
        
        
        mevc = [MasterEventWrapperViewController new];
        devc = [DetailEventWrapperViewController new];
        mevc.delegate = devc;
        mevc.detailEventWrapperViewController = devc;
        eventWrapperSplitView = [SplitViewController new];
        eventWrapperSplitView.viewControllers = @[mevc, devc];
        eventWrapperSplitView.delegate = devc;
        UITabBarItem *eventWrapperItem = [[UITabBarItem alloc] initWithTitle:@"Courses" image:[UIImage imageNamed:@"courses_unselected"] selectedImage:[UIImage imageNamed:@"courses_selected"]];
        
        eventWrapperSplitView.tabBarItem = eventWrapperItem;


        mmvc = [MasterMessageViewController new];
        dmvc = [DetailMessageViewController new];
        
        mmvc.delegate = dmvc;
        messagesSplitView = [[SplitViewController alloc]initWithLeftVC:mmvc rightVC:dmvc];
        UITabBarItem *messageItem = [[UITabBarItem alloc] initWithTitle:@"Messages" image:[UIImage imageNamed:@"messages_unselected"] selectedImage:[UIImage imageNamed:@"messages_selected"]];
        messagesSplitView.delegate = dmvc;
        messagesSplitView.tabBarItem = messageItem;
        
        
        muvc = [MasterUserViewController new];
        duvc = [DetailUserViewController new];
        muvc.delegate = duvc;
        usersSplitView = [SplitViewController new];
        usersSplitView.viewControllers = @[muvc, duvc];
        usersSplitView.delegate = duvc;
        UITabBarItem *userItem = [[UITabBarItem alloc]initWithTitle:@"Users" image:[UIImage imageNamed:@"users_unselected"] selectedImage:[UIImage imageNamed:@"users_selected"]];
        usersSplitView.tabBarItem = userItem;
        
        
        SchoolInfoViewController *locationViewController = [SchoolInfoViewController new];
        
        UITabBarItem *locationItem = [[UITabBarItem alloc] initWithTitle:@"Location" image:[UIImage imageNamed:@"location_unselected"] selectedImage:[UIImage imageNamed:@"location_selected"]];
        locationViewController.tabBarItem = locationItem;
        
        self.viewControllers = @[eventWrapperSplitView, messagesSplitView, usersSplitView, locationViewController];

    }
    return self;
}

@end
