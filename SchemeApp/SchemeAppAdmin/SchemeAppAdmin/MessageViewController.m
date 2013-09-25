//
//  MessageViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/24/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tabBarItem.title = @"Messages";
        self.tabBarItem.image = [UIImage imageNamed:@"messages_selected"];
    }
    return self;
}

@end
