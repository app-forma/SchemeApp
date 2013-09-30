//
//  LoginViewController.m
//  SchemeApp
//
//  Created by Marcus Norling on 9/12/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "LoginViewController.h"
#import "StudentEventMainViewController.h"
#import "AdminTabBarViewController.h"
#import "EventWrapper.h"

@interface LoginViewController () <UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)didPressSignIn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *loginStatusLabel;
- (IBAction)populateAdminCredentials:(id)sender;
- (IBAction)populateStudentCredentials:(id)sender;


@end

@implementation LoginViewController
{
    UIStoryboard *studentSb;
    UIStoryboard *adminSb;
    UIViewController *initialStudentVC;
    UIViewController *initialAdminVC;
}
-(void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    studentSb = [UIStoryboard storyboardWithName:@"StudentStoryboard" bundle:nil];
    initialStudentVC = [studentSb instantiateInitialViewController];

    adminSb = [UIStoryboard storyboardWithName:@"AdminEventWrapperStoryboard" bundle:nil];
    initialAdminVC = [adminSb instantiateInitialViewController];
}

#pragma mark text field delegate methods:
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (IBAction)didPressSignIn:(id)sender {
    [Store sendAuthenticationRequestForEmail:self.emailField.text password:self.passwordField.text completion:^(BOOL success, id user) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self isAdmin:user]) {
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
        initialAdminVC.modalTransitionStyle = UIModalPresentationFullScreen;
        [self presentViewController:[[AdminTabBarViewController alloc] init] animated:YES completion:nil];
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
        initialStudentVC.modalTransitionStyle = UIModalPresentationFullScreen;
        [self presentViewController:initialStudentVC animated:YES completion:nil];
    });
}

- (BOOL)isAdmin:(NSDictionary *)userDict
{
    if ([[userDict valueForKey:@"role"] isEqualToString:@"admin"] || [[userDict valueForKey:@"role"] isEqualToString:@"superadmin"]) {
        return YES;
    }
    return NO;
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
