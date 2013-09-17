//
//  AdminMessageViewController.m
//  SchemeApp
//
//  Created by Marcus Norling on 9/12/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminMessagesViewController.h"

@interface AdminMessagesViewController ()

@end

@implementation AdminMessagesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)loadView
{
    [super loadView];
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"messages_selected"]];
}
@end
