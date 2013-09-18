//
//  AdminEventWrapperTableViewViewController.m
//  SchemeApp
//
//  Created by Henrik on 2013-09-17.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminEventWrapperTableViewViewController.h"


@interface AdminEventWrapperTableViewViewController ()

@property (weak, nonatomic) IBOutlet UITextField *courseTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *teacherTextField;
@property (weak, nonatomic) IBOutlet UITextField *litteratureTextField;

@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateTimeLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *startDatePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;

@property (weak, nonatomic) IBOutlet UITableViewCell *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateTimeLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *endDatePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;

- (IBAction)setDateLabelsToPickerDates:(id)sender;

@end


@implementation AdminEventWrapperTableViewViewController
{
    BOOL shouldShowStartDatePicker, shouldShowEndDatePicker;
}

- (void)loadView
{
    [super loadView];
    
    shouldShowStartDatePicker = NO;
    shouldShowEndDatePicker = NO;
    
#warning Comment
    // When in details view diable tabar. Use will use back button to get back
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setDatePickerLocaleToSystemLocale];
    [self setDateLabelsToPickerDates:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
- (IBAction)setDateLabelsToPickerDates:(id)sender
{
    self.startDateDateLabel.text = [Helpers dateStringFromNSDate:self.startDatePicker.date];
    self.startDateTimeLabel.text = [Helpers timeStringFromNSDate:self.startDatePicker.date];
    self.endDateDateLabel.text = [Helpers dateStringFromNSDate:self.endDatePicker.date];
    self.endDateTimeLabel.text = [Helpers timeStringFromNSDate:self.endDatePicker.date];
}

@end
