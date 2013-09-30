//
//  PopoverUserViewController.m
//  SchemeAppAdmin
//
//  Created by Johan Thorell on 2013-09-26.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "PopoverUserViewController.h"

@interface PopoverUserViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *rolePickerView;
- (IBAction)saveUser:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;


@end

@implementation PopoverUserViewController
{
    NSArray *roles;
}
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
    roles = @[[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2]];
    self.rolePickerView.delegate = self;
    self.rolePickerView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (self.isInEditingMode) {
        [self.passwordTextField removeFromSuperview];
        [self.passwordLabel removeFromSuperview];
        [self.rolePickerView removeFromSuperview];
        [self.saveButton removeFromSuperview];
        
        User *currentUser = [self.delegate currentUser];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 320, 220)];
        self.rolePickerView.frame = CGRectMake(0, 10, 320, 180);
        self.saveButton.frame = CGRectMake(110, 165, 100, 40);
        [view addSubview:self.saveButton];
        [view addSubview:self.rolePickerView];
        [self.view addSubview:view];
        
        [self populateTextFieldsWith:currentUser for:@"PUT"];
        
        
    } else {
        [self populateTextFieldsWith:nil for:@"POST"];
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [roles count];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [User stringFromRoleType:[roles[row] intValue]];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

-(void)populateTextFieldsWith:(User *)user for:(NSString *)method
{
    if ([method isEqualToString:@"PUT"]) {
        self.firstnameTextField.text = user.firstname;
        self.lastnameTextField.text = user.lastname;
        self.emailTextField.text = user.email;
        self.passwordTextField.text = user.password;
        [self.rolePickerView selectRow:user.role inComponent:0 animated:NO];
        
        
    } else if ([method isEqualToString:@"POST"]) {
        self.firstnameTextField.text = @"";
        self.lastnameTextField.text = @"";
        self.emailTextField.text = @"";
        self.passwordTextField.text = @"";
    }
}

- (IBAction)saveUser:(id)sender {
    [self.delegate dismissPopover];
    
    if (self.isInEditingMode) {
        NSLog(@"PUT");
    } else {
        NSLog(@"POST");
    }
}
@end
