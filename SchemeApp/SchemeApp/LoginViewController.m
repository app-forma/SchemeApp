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
- (IBAction)didPressForgotPassword:(id)sender;

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
}

#pragma mark text field delegate methods:
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (IBAction)loadAdminSB:(id)sender {

    [Store setCurrentUserToUserWithEmail:@"joe@gmail.com" andPassword:nil completion:^(BOOL success) {
        if (success) {
            NSLog(@"Logged in as User: %@ %@", Store.mainStore.currentUser.firstname,
                  Store.mainStore.currentUser.lastname);
            [NSOperationQueue.mainQueue addOperationWithBlock:^
            {
                [self presentViewController:[[AdminTabBarViewController alloc] init] animated:YES completion:nil];
            }];
        }
    }];
    
}

- (IBAction)loadStudentSB:(id)sender {
//    UIStoryboard *studentSB = [UIStoryboard storyboardWithName:@"StudentStoryboard" bundle:nil];
//    UIViewController *initialVC = [studentSB instantiateInitialViewController];
    [Store setCurrentUserToUserWithEmail:@"joe@gmail.com" andPassword:nil completion:^(BOOL success) {

        if (success) {
            NSLog(@"Logged in as User: %@ %@", Store.mainStore.currentUser.firstname,
                  Store.mainStore.currentUser.lastname);
            initialStudentVC.modalTransitionStyle = UIModalPresentationFullScreen;
            [self presentViewController:initialStudentVC animated:YES completion:nil];
        }
    }];
    
    
}

- (IBAction)didPressSignIn:(id)sender {
    //For demo, setting a student to current user
    [Store setCurrentUserToUserWithEmail:self.emailField.text andPassword:nil completion:^(BOOL success) {
        if (success) {
            [self.view endEditing:YES];
            //Här har vi hämtat en user med alla eventwrappers, events och messages
            NSString *message = [NSString stringWithFormat:@"Login succeeded %@", Store.mainStore.currentUser.firstname];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hurray!" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            if ([[Store mainStore] currentUser].role == StudentRole) {
                initialStudentVC.modalTransitionStyle = UIModalPresentationFullScreen;
                [self presentViewController:initialStudentVC animated:YES completion:nil];
            }if ([[Store mainStore] currentUser].role == AdminRole || [[Store mainStore] currentUser].role == SuperAdminRole) {
                initialAdminVC.modalTransitionStyle = UIModalPresentationFullScreen;
                [self presentViewController:[[AdminTabBarViewController alloc] init] animated:YES completion:nil];
            }
           
        }else{
            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Stop" message:@"Login failed, check your email and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert2 show];
        }
    }];
    
//    NSDictionary *credentials = [[NSDictionary alloc]initWithObjects:@[self.emailField.text, self.passwordField.text] forKeys:@[@"email", @"password"]];
}

- (IBAction)didPressForgotPassword:(id)sender {
    NSLog(@"log in functionality not yet implemented.");
}
@end
