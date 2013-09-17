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

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)didPressSignIn:(id)sender;
- (IBAction)didPressForgotPassword:(id)sender;

@end

@implementation LoginViewController

-(void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    //For demo, setting a student to current user
    Store *store = [[Store alloc]init];
    [store setCurrentUserToUserWithEmail:@"joe@gmail.com" andPassword:nil completion:^(BOOL success) {
        
    }];
}

#pragma mark text field delegate methods:
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (IBAction)loadAdminSB:(id)sender {
    [self presentViewController:[[AdminTabBarViewController alloc] init] animated:YES completion:nil];
}

- (IBAction)loadStudentSB:(id)sender {
    UIStoryboard *studentSB = [UIStoryboard storyboardWithName:@"StudentStoryboard" bundle:nil];
    UIViewController *initialVC = [studentSB instantiateInitialViewController];
    initialVC.modalTransitionStyle = UIModalPresentationFullScreen;
    [self presentViewController:initialVC animated:YES completion:nil];
}

- (IBAction)didPressSignIn:(id)sender {
    NSLog(@"log in functionality not yet implemented.");
    NSDictionary *credentials = [[NSDictionary alloc]initWithObjects:@[self.emailField.text, self.passwordField.text] forKeys:@[@"email", @"password"]];
}

- (IBAction)didPressForgotPassword:(id)sender {
    NSLog(@"log in functionality not yet implemented.");
}
@end
