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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender
{
    NSLog(@"Email: %@", self.loginEmailTextField.text);
    NSLog(@"Password: %@", self.loginEmailTextField.text);
    [Store setCurrentUserToUserWithEmail:@"joe@gmail.com"
                             andPassword:nil
                              completion:^(BOOL success)
    {
        if (success)
        {
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
                        
            //[self.delegate didSuccesfullyLogin];
        }
        else
        {
            NSLog(@"[%@] Could not login.", self.class);
        }
    }];
}
@end
