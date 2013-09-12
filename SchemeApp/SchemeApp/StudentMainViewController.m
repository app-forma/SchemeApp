//
//  StudentMainViewController.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/11/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentMainViewController.h"
#import "DatePickerViewController.h"

@interface StudentMainViewController () <UITableViewDelegate, UITableViewDataSource>
{
    DatePickerViewController *datePicker;
    UIView *datePickerView;
}

@property (weak, nonatomic) IBOutlet UILabel *startDateForScheme;
@property (weak, nonatomic) IBOutlet UILabel *endDateForScheme;
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;

@end


@implementation StudentMainViewController

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
    
    self.navigationItem.title = @"Home";
    
    self.messagesTableView.delegate = self;
    self.messagesTableView.dataSource = self;
    
    datePicker = [[DatePickerViewController alloc] init];
    
    UITapGestureRecognizer *tapForStartDate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickStartDateForScheme)];
    [self.startDateForScheme addGestureRecognizer:tapForStartDate];
    
    UITapGestureRecognizer *tapForEndDate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickEndDateForScheme)];
    [self.endDateForScheme addGestureRecognizer:tapForEndDate];
    
    datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 380, 320, 206)];
    [datePickerView addSubview:datePicker.view];
    [self.view addSubview:datePickerView];
    datePickerView.hidden = YES;
    
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5; // returnera antalet meddelanden som finns tillgängliga för eleven. MessageStore?
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Skapa en custom cell. Lärarens namn, datum och början av meddelandet.
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Här ska vi skapa en StudentMessageDetailsViewController och sen ska vi pusha den med detaljer för den valda radens meddelande.
}



@end
