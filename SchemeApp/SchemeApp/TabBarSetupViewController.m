//
//  AdminTabBarViewController.m
//  SchemeApp
//
//  Created by Henrik on 2013-09-17.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "TabBarSetupViewController.h"
#import "StudentAutomaticPresence.h"

@implementation TabBarSetupViewController
{
    UIActionSheet *signOutPopup;
    StudentAutomaticPresence *attendanceMonitor;
}
-(id)initForRoleType:(RoleType)role;
{
    self = [super init];
    if (self) {        
         signOutPopup = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Sign out" otherButtonTitles:nil, nil];
        
        if (role == StudentRole) {
            [self checkAttendance];
            [self setupTabBarWithStoryboards:@[@"StudentMessagesStoryboard", @"StudentEventsStoryBoard", @"StudentWhatToReadStoryboard"]];

        } else {
            [self setupTabBarWithStoryboards:@[@"AdminEventWrapperStoryboard", @"AdminMessagesStoryboard", @"AdminUserStoryboard"]];
        }
    }
    return self;
}

- (void)checkAttendance {
    NSString *dateString = [Helpers dateStringFromNSDate:[NSDate date]];
    NSString *latestAttendanceDateString = [NSUserDefaults.standardUserDefaults objectForKey:@"latestAttendance"];
    BOOL attendanceForTodayNotSent = ![latestAttendanceDateString isEqualToString:dateString];
    
    if (attendanceForTodayNotSent) {
        [Store fetchLocationCompletion:^(Location *location) {
            if (location) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    attendanceMonitor = [[StudentAutomaticPresence alloc] initWithSchoolLocation:location];
                });
            }
        }];
    } else {
        NSLog(@"Attendance already set.");
    }
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
        //sign ut
        attendanceMonitor = nil;
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
