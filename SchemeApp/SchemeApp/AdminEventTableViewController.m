//
//  AdminEventTableViewController.m
//  SchemeApp
//
//  Created by Henrik on 2013-09-19.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminEventTableViewController.h"
#import "Event.h"
#import "EventWrapper.h"


@interface AdminEventTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *infoTextField;
@property (weak, nonatomic) IBOutlet UITextField *roomTextField;

@property (weak, nonatomic) IBOutlet UILabel *startDateDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateTimeLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *startDatePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;

@property (weak, nonatomic) IBOutlet UILabel *endDateDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateTimeLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *endDatePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;

@end


@implementation AdminEventTableViewController
{
    BOOL shouldShowStartDatePicker, shouldShowEndDatePicker;
}

- (void)loadView
{
    [super loadView];
    
    shouldShowStartDatePicker = NO;
    shouldShowEndDatePicker = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!self.isNew)
    {
        [self setInputsToSelectedEvent];
    }

    [self setDatePickerLocaleToSystemLocale];
    [self setDateLabelsToPickerDates:nil];
}

- (void)toggleStartDatePicker
{
    shouldShowStartDatePicker = !shouldShowStartDatePicker;
    [self updateTableView];
}
- (void)toggleEndDatePicker
{
    shouldShowEndDatePicker = !shouldShowEndDatePicker;
    [self updateTableView];
}

- (IBAction)setDateLabelsToPickerDates:(id)sender
{
    self.startDateDateLabel.text = [Helpers dateStringFromNSDate:self.startDatePicker.date];
    self.startDateTimeLabel.text = [Helpers timeStringFromNSDate:self.startDatePicker.date];
    self.endDateDateLabel.text = [Helpers dateStringFromNSDate:self.endDatePicker.date];
    self.endDateTimeLabel.text = [Helpers timeStringFromNSDate:self.endDatePicker.date];
}
- (IBAction)save:(id)sender
{
    void(^saveHandler)(void) = ^(void)
    {
        [NSOperationQueue.mainQueue addOperationWithBlock:^
         {
             [self.navigationController popViewControllerAnimated:YES];
         }];
    };
    
    if (self.isNew)
    {
        self.selectedEvent = [[Event alloc] init];
        [self setSelectedEventPropertiesToInputValues];
        [Store.adminStore createEvent:self.selectedEvent
                           completion:^(id jsonObject, id response, NSError *error)
         {
             if (error)
             {
                 NSLog(@"save: got response: %@ and error: %@", response, error.userInfo);
                 saveHandler();
             }
             else
             {
#warning Testing
                 NSLog(@"jsonObject: %@", jsonObject);
                 [self.selectedEventWrapper.events addObject:[[Event alloc] initWithEventDictionary:jsonObject]];
                 [Store.adminStore updateEventWrapper:self.selectedEventWrapper
                                           completion:^(id jsonObject, id response, NSError *error)
                  {
                      if (error)
                      {
                          NSLog(@"save: got response: %@ and error: %@", response, error.userInfo);
                      }
                      saveHandler();
                  }];
             }
         }];
    }
    else
    {
        [self setSelectedEventPropertiesToInputValues];
        [Store.adminStore updateEvent:self.selectedEvent
                           completion:^(id jsonObject, id response, NSError *error)
         {
             if (error)
             {
                 NSLog(@"save: got response: %@ and error: %@", response, error);
             }
             saveHandler();
         }];
    }
}

#pragma mark - UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 44.0;
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 1)
        {
            if (shouldShowStartDatePicker)
            {
                rowHeight = 200.0f;
            }
            else
            {
                rowHeight = 0.0f;
            }
        }
        if (indexPath.row == 3)
        {
            if (shouldShowEndDatePicker)
            {
                rowHeight = 200.0f;
            }
            else
            {
                rowHeight = 0.0f;
            }
        }
    }
    
    return rowHeight;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            [self toggleStartDatePicker];
        }
        if (indexPath.row == 2)
        {
            [self toggleEndDatePicker];
        }
    }
}

#pragma mark - Extracted methods
- (void)updateTableView
{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
- (void)setDatePickerLocaleToSystemLocale
{
    self.startDatePicker.locale = [NSLocale systemLocale];
    self.endDatePicker.locale = [NSLocale systemLocale];
}
- (void)setInputsToSelectedEvent
{
    self.infoTextField.text = self.selectedEvent.info;
    self.roomTextField.text = self.selectedEvent.room;
    self.startDatePicker.date = self.selectedEvent.startDate;
    self.endDatePicker.date = self.selectedEvent.endDate;
}
- (void)setSelectedEventPropertiesToInputValues
{
    self.selectedEvent.info = self.infoTextField.text;
    self.selectedEvent.room = self.roomTextField.text;
    self.selectedEvent.startDate = self.startDatePicker.date;
    self.selectedEvent.endDate = self.endDatePicker.date;
}

@end
