//
//  UsersViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/24/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "UsersViewController.h"

@interface UsersViewController ()

@end

@implementation UsersViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tabBarItem.title = @"Users";
        self.tabBarItem.image = [UIImage imageNamed:@"users_selected"];
    }
    return self;
}

@end
