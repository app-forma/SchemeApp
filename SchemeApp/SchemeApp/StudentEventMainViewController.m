//
//  StudentMainViewController.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/11/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentEventMainViewController.h"
#import "DatePickerViewController.h"
#import "Event.h"
#import "EventWrapper.h"
#import "StudentEventsTableViewController.h"
#import "User.h"
@interface StudentEventMainViewController ()<DatePickerDelegate>
{
    DatePickerViewController *datePicker;
    UIView *datePickerView;
    NSMutableArray *events;
    UIAlertView *pickDate;
}

@property (weak, nonatomic) IBOutlet UILabel *startDateForScheme;
@property (weak, nonatomic) IBOutlet UILabel *endDateForScheme;

@end


@implementation StudentEventMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pickDate = [[UIAlertView alloc] initWithTitle:@"Pick Date" message:@"You have to pick a start date and an end date!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    events = [NSMutableArray new];
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"courses_selected.png"]];

    self.navigationItem.title = @"Classes";
    
    // Sign out
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOut)];
    self.navigationItem.rightBarButtonItem = signOutButton;
    
    
    datePicker = [[DatePickerViewController alloc] init];
    
    UITapGestureRecognizer *tapForStartDate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickStartDateForScheme)];
    [self.startDateForScheme addGestureRecognizer:tapForStartDate];
    
    UITapGestureRecognizer *tapForEndDate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickEndDateForScheme)];
    [self.endDateForScheme addGestureRecognizer:tapForEndDate];
    
    datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 260, 320, 206)];
    [datePickerView addSubview:datePicker.view];
    [self.view addSubview:datePickerView];
    datePickerView.hidden = YES;
    datePicker.delegate = self;
}

-(void)signOut
{
    UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    UIViewController *initialLoginVC = [loginSb instantiateInitialViewController];
    initialLoginVC.modalTransitionStyle = UIModalPresentationFullScreen;
    [self presentViewController:initialLoginVC animated:YES completion:nil];
}

-(void)DatePickerDonePickingDate:(NSDate *)datePicked
{
    datePickerView.hidden = YES;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateText = [dateFormat stringFromDate:datePicked];
    if (datePicker.currentDatePicker == StartDatePicker) {
        self.startDateForScheme.text = dateText;
    }else if (datePicker.currentDatePicker == EndDatePicker){
        self.endDateForScheme.text = dateText;
    }
}

- (IBAction)getSchemeForToday:(id)sender
{
    NSDictionary *today = [Helpers startAndEndTimeForDate:[NSDate date]];
    [self getEvents:@{@"startDate": [Helpers dateFromString:today[@"startTime"]], @"endDate": [Helpers dateFromString:today[@"endTime"]]}];
}

- (IBAction)getSchemeForTheWeek:(id)sender
{
    NSDictionary *week = [Helpers startAndEndDateOfWeekForDate:[NSDate date]];
    [self getEvents:@{@"startDate": [Helpers dateFromString:week[@"startDate"]], @"endDate": [Helpers dateFromString:week[@"endDate"]]}];
}

- (IBAction)getScheme:(id)sender
{
    
    NSDate *startDate = [Helpers stripStartDateFromTime:[Helpers dateFromString:self.startDateForScheme.text]];
    NSDate *endDate = [Helpers stripEndDateFromTime:[Helpers dateFromString:self.endDateForScheme.text]];
    NSDictionary *dateDic = [[NSDictionary alloc] initWithObjectsAndKeys:startDate, @"startDate", endDate, @"endDate", nil];
    
    NSDate *checkDate = [Helpers dateFromString:@"2005-01-01 12:00"];
    if ([[startDate laterDate:checkDate] isEqual:startDate] && [[endDate laterDate:checkDate] isEqual:endDate]) {
        [self getEvents:dateDic];
    } else {
        [pickDate show];
    }
}


-(void)getEvents:(NSDictionary *)dateDic
{
    StudentEventsTableViewController *setvc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentEventsTableViewController"];
    setvc.eventsWithEventWrapper = [self filteredDatesForScheme:dateDic];
    [self.navigationController pushViewController:setvc animated:YES];
}

-(NSMutableArray *)filteredDatesForScheme:(NSDictionary *)dateDic
{
    NSMutableArray *filteredArray = [NSMutableArray new];
    for (EventWrapper *eventWrapper in Store.mainStore.currentUser.eventWrappers){
        for (Event *event in eventWrapper.events){
            if ([[dateDic[@"startDate"] laterDate:event.startDate] isEqual:event.startDate] && [[dateDic[@"endDate"] earlierDate:event.startDate] isEqual:event.startDate]) {
                NSDictionary *eDic = @{@"eventWrapper": eventWrapper, @"event": event};
                [filteredArray addObject:eDic];
            }
        }
    }
    return filteredArray;
}

-(void)pickStartDateForScheme
{
    datePicker.currentDatePicker = StartDatePicker;
    datePickerView.hidden = NO;
}

-(void)pickEndDateForScheme
{
    datePicker.currentDatePicker = EndDatePicker;
    datePickerView.hidden = NO;
}

@end
