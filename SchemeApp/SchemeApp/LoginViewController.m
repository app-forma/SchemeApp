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
@property (weak, nonatomic) IBOutlet UILabel *loginStatusLabel;

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
    
    
    /* IF STUDENT ADD ATTENDANCE
     if (Store.mainStore.currentUser.role == StudentRole)
     {
     [Store.studentStore addAttendanceCompletion:^(BOOL success)
     {
     if (!success)
     {
     NSLog(@"[%@] Could not register attendance for current user %@", self.class, Store.mainStore.currentUser.email);
     }
     }];
     }
     */
    
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
    
    //    [Store setCurrentUserToUserWithEmail:self.emailField.text andPassword:nil completion:^(BOOL success) {
    //        if (success) {
    //            [self.view endEditing:YES];
    //            //Här har vi hämtat en user med alla eventwrappers, events och messages
    //            NSString *message = [NSString stringWithFormat:@"Login succeeded %@", Store.mainStore.currentUser.firstname];
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hurray!" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //            [alert show];
    //            if ([[Store mainStore] currentUser].role == StudentRole) {
    //                initialStudentVC.modalTransitionStyle = UIModalPresentationFullScreen;
    //                [self presentViewController:initialStudentVC animated:YES completion:nil];
    //            }if ([[Store mainStore] currentUser].role == AdminRole || [[Store mainStore] currentUser].role == SuperAdminRole) {
    //                initialAdminVC.modalTransitionStyle = UIModalPresentationFullScreen;
    //                [self presentViewController:[[AdminTabBarViewController alloc] init] animated:YES completion:nil];
    //            }
    //
    //        }else{
    //            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Stop" message:@"Login failed, check your email and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //            [alert2 show];
    //        }
    //    }];
    
    //    NSDictionary *credentials = [[NSDictionary alloc]initWithObjects:@[self.emailField.text, self.passwordField.text] forKeys:@[@"email", @"password"]];
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
@end
