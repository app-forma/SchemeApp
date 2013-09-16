//
//  AdminEditStudentViewController.m
//  SchemeApp
//
//  Created by Henrik on 2013-09-16.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminEditStudentViewController.h"


@interface AdminEditStudentViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstnameTestLabel;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextLabel;

@end


@implementation AdminEditStudentViewController
{
    RoleType selectedRoleType;
}

- (IBAction)save:(id)sender
{
#warning Implement
    User *user = [[User alloc] initWithDocID:@""
                                        Role:selectedRoleType
                                   firstname:self.firstnameTestLabel.text
                                    lastname:self.lastnameTextLabel.text
                                       email:self.emailTextLabel.text
                                    password:self.passwordTextLabel.text];
    
    [Store.superAdminStore createUser:user];
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
            selectedRoleType = StudentRole;
            break;
        case 1:
            selectedRoleType = AdminRole;
            break;
        case 2:
            selectedRoleType = SuperAdminRole;
            break;
        default:
            selectedRoleType = StudentRole;
            break;
    }
}

@end
