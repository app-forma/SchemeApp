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
    
    
    
   
}

@property (weak, nonatomic) IBOutlet UILabel *startDateForScheme;
@property (weak, nonatomic) IBOutlet UILabel *endDateForScheme;


@end


@implementation StudentEventMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    events = [NSMutableArray new];
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"courses_selected.png"]];

    self.navigationItem.title = @"Classes";
    
    
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
-(void)DatePickerDonePickingDate:(NSDate *)datePicked
{
    
    datePickerView.hidden = YES;
    NSString *dateText = [Helpers stringFromNSDate:datePicked];
    if (datePicker.currentDatePicker == StartDatePicker) {
        self.startDateForScheme.text = dateText;
    }else if (datePicker.currentDatePicker == EndDatePicker){
        self.endDateForScheme.text = dateText;
    }
}

- (IBAction)getScheme:(id)sender
{
    
    

    StudentEventsTableViewController *setvc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentEventsTableViewController"];
    setvc.eventsWithEventWrapper = [self filteredDatesForScheme];
    [self.navigationController pushViewController:setvc animated:YES];
    

   
    
}
-(NSMutableArray *)filteredDatesForScheme
{
    NSDate *startDate = [Helpers stripStartDateFromTime:[Helpers dateFromString:self.startDateForScheme.text]];
    NSDate *endDate = [Helpers stripEndDateFromTime:[Helpers dateFromString:self.endDateForScheme.text]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(startDate >= %@) AND (startDate <= %@)", startDate, endDate];
    
    NSMutableArray *eArray = [NSMutableArray new];
    for (EventWrapper *eventWrapper in Store.mainStore.currentUser.eventWrappers){
        for (Event *event in eventWrapper.events){
            NSDictionary *eDic = @{@"eventWrapper": eventWrapper, @"event": event};
            [eArray addObject:eDic];
        }
    }
    NSArray *evArray = [[eArray valueForKey:@"event"] filteredArrayUsingPredicate:predicate];
    NSMutableArray *filteredArray = [NSMutableArray new];
    for (EventWrapper *eventWrapper in Store.mainStore.currentUser.eventWrappers){
        for (Event *event in eventWrapper.events){
            
            for (int i = 0; i < evArray.count; i++) {
                Event *e = evArray[i];
                if ([e.docID isEqualToString:event.docID]) {
            NSDictionary *eDic = @{@"eventWrapper": eventWrapper, @"event": event};
                    [filteredArray addObject:eDic];
                }
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
