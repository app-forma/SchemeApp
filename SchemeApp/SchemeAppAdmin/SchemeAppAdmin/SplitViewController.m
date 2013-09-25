//
//  SplitViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "SplitViewController.h"

@interface SplitViewController ()

@end

@implementation SplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithLeftVC:(UIViewController *)leftVC rightVC:(UIViewController *)rightVC{
    self = [super init];
    if (self) {
        self.viewControllers = @[leftVC, rightVC];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


@end
