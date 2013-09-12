//
//  StudentMainViewController.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/11/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentMainViewController.h"
#import "DatePickerViewController.h"
#import "MessageCell.h"
#import "Message.h"
#import "User.h"
#import "Helpers.h"

@interface StudentMainViewController () <UITableViewDelegate, UITableViewDataSource>
{
    DatePickerViewController *datePicker;
    UIView *datePickerView;
    
    
    
    
    //for testing:
    NSArray *messages;
}

@property (weak, nonatomic) IBOutlet UILabel *startDateForScheme;
@property (weak, nonatomic) IBOutlet UILabel *endDateForScheme;


@end


@implementation StudentMainViewController

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
    User *lasse = [[User alloc]initWithRole:SuperAdminRole firstname:@"lasse" lastname:@"erikssom" email:@"laase@fjghafd.se" password:@"123456"];
    
    Message *mess1 = [[Message alloc]init];
    mess1.from = lasse;
    mess1.date = [NSDate date];
    mess1.text = @"asdkjfghasdkgajhgdka";
    
    
    User *master = [[User alloc]initWithRole:SuperAdminRole firstname:@"Anders" lastname:@"Carlsson" email:@"anders@coredev.se" password:@"Master"];
    
    Message *mess2 = [[Message alloc]init];
    mess2.from = master;
    mess2.date = [NSDate date];
    mess2.text = @"Hej grabbar! Jag har kollat i ert repository och det ser lite stökigt ut. Hur är det med Git-kunskaperna?";
    
    messages = @[mess1, mess2];
    
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
    return messages.count; // returnera antalet meddelanden som finns tillgängliga för eleven. MessageStore?
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Skapa en custom cell. Lärarens namn, datum och början av meddelandet.
    
    static NSString *cellId = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    Message *message = messages[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", message.from.firstname, message.from.lastname];
    cell.dateLabel.text = [Helpers stringFromNSDate:message.date];
    cell.messageTextView.text = message.text;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Här ska vi skapa en StudentMessageDetailsViewController och sen ska vi pusha den med detaljer för den valda radens meddelande.
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Messages";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}

@end
