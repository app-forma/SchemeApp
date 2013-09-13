//
//  StudentMainViewController.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/11/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentEventMainViewController.h"
#import "DatePickerViewController.h"


@interface StudentEventMainViewController ()
{
    DatePickerViewController *datePicker;
    UIView *datePickerView;
    
    
    
    
   
}

@property (weak, nonatomic) IBOutlet UILabel *startDateForScheme;
@property (weak, nonatomic) IBOutlet UILabel *endDateForScheme;


@end


@implementation StudentEventMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Home";
    
    
    datePicker = [[DatePickerViewController alloc] init];
    
    UITapGestureRecognizer *tapForStartDate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickStartDateForScheme)];
    [self.startDateForScheme addGestureRecognizer:tapForStartDate];
    
    UITapGestureRecognizer *tapForEndDate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickEndDateForScheme)];
    [self.endDateForScheme addGestureRecognizer:tapForEndDate];
    
    datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 380, 320, 206)];
    [datePickerView addSubview:datePicker.view];
    [self.view addSubview:datePickerView];
    datePickerView.hidden = YES;
    
    //dummy data
    
    
}


- (IBAction)getScheme:(id)sender
{
    NSLog(@"Get scheme with start date and end date for student with id");
}

-(void)pickStartDateForScheme
{
    NSLog(@"Pick start date from det date picker that just popped up!");
    NSLog(@"Update the labels text with the date that was picked!");
    datePickerView.hidden = NO;
}

-(void)pickEndDateForScheme
{
    NSLog(@"Pick end date from det date picker that just popped up!");
    NSLog(@"Update the labels text with the date that was picked!");
    datePickerView.hidden = NO;
}



@end
