//
//  StudentEventDetailsViewController.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/11/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentEventDetailsViewController.h"

@interface StudentEventDetailsViewController ()

@end

@implementation StudentEventDetailsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


// En vy med details för det valda eventet av studenten.



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Event";
}

@end
