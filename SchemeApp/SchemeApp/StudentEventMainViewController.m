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
    self.navigationItem.title = @"";
    
    
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
    NSDate *startDate = [Helpers dateFromString:self.startDateForScheme.text];
    NSDate *endDate = [Helpers dateFromString:self.endDateForScheme.text];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    
    [[Store studentStore] eventWrappersWithStartDate:startDate andEndDate:endDate completion:^(NSArray *eventWrappers) {

        for (NSDictionary *jsonEventWrapper in eventWrappers)
        {
            NSMutableDictionary *eventWrapperDic = [NSMutableDictionary dictionaryWithDictionary:jsonEventWrapper];
//            NSDictionary *userDic = jsonEventWrapper[@"owner"];
//            if (userDic) {
//                User *user = [[User alloc] initWithUserDictionary:userDic];
//                [eventWrapperDic setObject:user forKey:@"owner"];
//            }
 

            

            
            EventWrapper *eventWrapper = [[EventWrapper alloc]initWithEventWrapperDictionary:eventWrapperDic];

            NSArray *jsonEvents = jsonEventWrapper[@"events"];
            for (NSDictionary *jsonEvent in jsonEvents){
                Event *event = [[Event alloc]initWithEventDictionary:jsonEvent];
                NSDictionary *eventDic = @{@"event": event, @"eventWrapper": eventWrapper};
                [events addObject:eventDic];
            }
            }
        StudentEventsTableViewController *setvc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentEventsTableViewController"];
        setvc.eventsWithEventWrapper = events;
        [self.navigationController pushViewController:setvc animated:YES];
    }];

   
    
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
