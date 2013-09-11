//
//  LoginViewController.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/10/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginInput;

@end


@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginInput.delegate = self;
}


#pragma mark - Sign in

- (IBAction)signIn:(id)sender
{
    NSLog(@"Signing in with e-mail: %@ and pushing corresponding view controller", self.loginInput.text);
}


#pragma mark - Text field delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




@end
