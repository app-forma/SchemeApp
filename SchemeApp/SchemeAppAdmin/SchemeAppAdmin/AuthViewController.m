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

#warning TEST
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.loginEmailTextField.text = @"aa@a.se";
    self.loginPasswordField.text = @"asdf";
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
    [Store sendAuthenticationRequestForEmail:self.loginEmailTextField.text password:self.loginPasswordField.text completion:^(BOOL success, id user) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                Store.mainStore.currentUser = [[User alloc] initWithUserDictionary:user];

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