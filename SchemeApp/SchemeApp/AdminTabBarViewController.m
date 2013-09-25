//
//  AdminTabBarViewController.m
//  SchemeApp
//
//  Created by Henrik on 2013-09-17.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminTabBarViewController.h"


@implementation AdminTabBarViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setupAdminTabBarViewController];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupAdminTabBarViewController];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupAdminTabBarViewController];
    }
    return self;
}
- (void)setupAdminTabBarViewController
{
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:[[UIStoryboard storyboardWithName:@"AdminEventWrapperStoryboard" bundle:nil] instantiateInitialViewController]];
    [array addObject:[[UIStoryboard storyboardWithName:@"AdminMessagesStoryboard" bundle:nil] instantiateInitialViewController]];
    [array addObject:[[UIStoryboard storyboardWithName:@"AdminUserStoryboard" bundle:nil] instantiateInitialViewController]];
    
    self.viewControllers = array;
}

@end
