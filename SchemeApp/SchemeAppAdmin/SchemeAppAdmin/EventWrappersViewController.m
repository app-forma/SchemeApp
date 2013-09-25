//
//  EventWrappersViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/24/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "EventWrappersViewController.h"

@interface EventWrappersViewController ()

@end

@implementation EventWrappersViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tabBarItem.title = @"Courses";
        self.tabBarItem.image = [UIImage imageNamed:@"courses_selected"];
    }
    return self;
}

@end
