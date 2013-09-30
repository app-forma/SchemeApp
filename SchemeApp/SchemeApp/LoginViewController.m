//
//  LoginViewController.m
//  SchemeApp
//
//  Created by Marcus Norling on 9/12/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "LoginViewController.h"
#import "AdminTabBarViewController.h"

@interface LoginViewController () <UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *loginStatusLabel;
- (IBAction)didPressSignIn:(id)sender;
- (IBAction)populateAdminCredentials:(id)sender;
- (IBAction)populateStudentCredentials:(id)sender;

@end

@implementation LoginViewController

#pragma mark text field delegate methods:
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (IBAction)didPressSignIn:(id)sender {
    [Store sendAuthenticationRequestForEmail:self.emailField.text password:self.passwordField.text completion:^(BOOL success, id user) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([Store mainStore].currentUser.role != StudentRole) {
                    [self adminDidLogin];
                } else {
                    [self studentDidLogin];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loginStatusLabel.text = @"Invalid credentials, try again";
            });
        }
    }];
}

- (void)adminDidLogin
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AdminTabBarViewController *adminTabBar = [[AdminTabBarViewController alloc]init];
        adminTabBar.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adminTabBar animated:YES completion:nil];
    });
}

- (void)studentDidLogin
{
    [Store.studentStore addAttendanceCompletion:^(BOOL success)
     {
         if (!success)
         {
             NSLog(@"[%@] Could not register attendance for current user %@", self.class, Store.mainStore.currentUser.email);
         }
     }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *initialStudentVC = [[UIStoryboard storyboardWithName:@"StudentStoryboard" bundle:nil]instantiateInitialViewController];
        initialStudentVC.modalTransitionStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:initialStudentVC animated:YES completion:nil];
    });
}

- (IBAction)populateAdminCredentials:(id)sender {
    self.emailField.text = @"anders@coredev.se";
    self.passwordField.text = @"anders";
}

- (IBAction)populateStudentCredentials:(id)sender {
    self.emailField.text = @"tobie@tobie.se";
    self.passwordField.text = @"tobie";
}

@end
