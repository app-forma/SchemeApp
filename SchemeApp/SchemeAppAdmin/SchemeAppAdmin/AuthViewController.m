//
//  AuthViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/24/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "AuthViewController.h"

@interface AuthViewController ()
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *loginStatusLabel;
@property (weak, nonatomic) IBOutlet UITextField *loginEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordField;

@end

@implementation AuthViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.loginEmailTextField.text = @"anders@coredev.se";
    self.loginPasswordField.text = @"anders";
}

- (IBAction)login:(id)sender
{
    [Store sendAuthenticationRequestForEmail:self.loginEmailTextField.text password:self.loginPasswordField.text completion:^(BOOL success, id user) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{                
                [self.delegate didSuccesfullyLogin];                
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loginStatusLabel.text = @"Invalid credentials, try again";
            });
        }
    }];
}
@end
