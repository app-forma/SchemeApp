//
//  DatePickerViewController.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/12/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
}

- (IBAction)donePickingDate:(id)sender
{
    NSLog(@"Date picked!");
    self.view.hidden = YES;
}

@end
