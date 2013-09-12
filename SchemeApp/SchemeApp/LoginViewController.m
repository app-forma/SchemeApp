//
//  LoginViewController.m
//  SchemeApp
//
//  Created by Marcus Norling on 9/12/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "LoginViewController.h"
#import "StudentMainViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (IBAction)loadAdminSB:(id)sender {
    UIStoryboard *adminSB = [UIStoryboard storyboardWithName:@"AdminStoryboard" bundle:nil];
    UIViewController *initialVC = [adminSB instantiateInitialViewController];
    initialVC.modalTransitionStyle = UIModalPresentationFullScreen;
    presentViewController:animated:completion:
    [self presentViewController:initialVC animated:YES completion:nil];
}

- (IBAction)loadStudentSB:(id)sender {
    UIStoryboard *studentSB = [UIStoryboard storyboardWithName:@"StudentStoryboard" bundle:nil];
    UIViewController *initialVC = [studentSB instantiateInitialViewController];
    initialVC.modalTransitionStyle = UIModalPresentationFullScreen;
    [self presentViewController:initialVC animated:YES completion:nil];
}
@end
