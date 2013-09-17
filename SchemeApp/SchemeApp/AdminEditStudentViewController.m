//
//  AdminEditStudentViewController.m
//  SchemeApp
//
//  Created by Henrik on 2013-09-16.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminEditStudentViewController.h"
#import "User.h"


@interface AdminEditStudentViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic) RoleType selectedRoleType;

@end


@implementation AdminEditStudentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.selectedUser)
    {
        self.firstnameTextField.text = self.selectedUser.firstname;
        self.lastnameTextField.text = self.selectedUser.lastname;
        self.emailTextField.text = self.selectedUser.email;
        self.passwordTextField.text = self.selectedUser.password;
        self.selectedRoleType = self.selectedUser.role;
        
        [self.pickerView selectRow:self.selectedRoleType inComponent:0 animated:NO];
    }
}

- (IBAction)save:(id)sender
{
    if (self.selectedUser)
    {
        self.selectedUser.firstname = self.firstnameTextField.text;
        self.selectedUser.lastname = self.lastnameTextField.text;
        self.selectedUser.email = self.emailTextField.text;
        self.selectedUser.password = self.passwordTextField.text;
        self.selectedUser.role = self.selectedRoleType;
        [Store.superAdminStore updateUser:self.selectedUser];
    }
    else
    {
        User *user = [[User alloc] initWithDocID:@""
                                            Role:self.selectedRoleType
                                       firstname:self.firstnameTextField.text
                                        lastname:self.lastnameTextField.text
                                           email:self.emailTextField.text
                                        password:self.passwordTextField.text];
        
        [Store.superAdminStore createUser:user];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    UITextField *nextField = (UITextField*)[self.view viewWithTag:textField.tag + 1];
    [nextField becomeFirstResponder];
    
    return YES;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (row)
    {
        case 0:
            return @"Student";
            break;
        case 1:
            return @"Admin";
            break;
        case 2:
            return @"SuperAdmin";
            break;
        default:
            return @"";
            break;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (row)
    {
        case 0:
            self.selectedRoleType = StudentRole;
            break;
        case 1:
            self.selectedRoleType = AdminRole;
            break;
        case 2:
            self.selectedRoleType = SuperAdminRole;
            break;
        default:
            self.selectedRoleType = StudentRole;
            break;
    }
}

@end
