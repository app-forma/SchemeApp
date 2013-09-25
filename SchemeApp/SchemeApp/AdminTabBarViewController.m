//
//  AdminTabBarViewController.m
//  SchemeApp
//
//  Created by Henrik on 2013-09-17.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminTabBarViewController.h"
#import "EventWrappersViewController.h"
#import "MessageViewController.h"
#import "UsersViewController.h"
#import "SchoolInfoViewController.h"

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
    
    [array addObject:[[EventWrappersViewController alloc] init]];
    [array addObject:[[MessageViewController alloc] init]];
    [array addObject:[[UsersViewController alloc] init]];
    [array addObject:[[SchoolInfoViewController alloc] init]];
    
    self.viewControllers = array;
}

@end
