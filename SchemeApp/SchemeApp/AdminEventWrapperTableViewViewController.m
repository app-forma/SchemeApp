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
@property (weak, nonatomic) IBOutlet UITableViewCell *startDatePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UITableViewCell *endDateLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *endDatePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;

@end


@implementation AdminEventWrapperTableViewViewController
{
    BOOL shouldShowStartDatePicker, shouldShowEndDatePicker;
}

-(void)loadView
{
    [super loadView];
    
    shouldShowStartDatePicker = NO;
    shouldShowEndDatePicker = NO;
    
#warning Comment
    // When in details view diable tabar. Use will use back button to get back
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)toggleStartDatePicker
{
    shouldShowStartDatePicker = !shouldShowStartDatePicker;
    self.startDatePicker.hidden = !self.startDatePicker.hidden;
    [self updateTableView];
}
- (void)toggleEndDatePicker
{
    shouldShowEndDatePicker = !shouldShowEndDatePicker;
    self.endDatePicker.hidden = !self.endDatePicker.hidden;
    [self updateTableView];
}

#pragma mark - UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight;
    switch (indexPath.section)
    {
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    if (shouldShowStartDatePicker)
                    {
                        rowHeight =  162;
                    }
                    else
                    {
                        rowHeight = 0;
                    }
                    break;
                }
                case 2:
                {
                    if (shouldShowEndDatePicker)
                    {
                        rowHeight = 162;
                    }
                    else
                    {
                        rowHeight = 0;
                    }
                    break;
                }
                default:
                {
                    rowHeight = 44;
                    break;
                }
            }
            break;
        }
        default:
        {
            rowHeight = 44;
            break;
        }
    }
    return rowHeight;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    [self toggleStartDatePicker];
                    break;
                }
                case 2:
                {
                    [self toggleEndDatePicker];
                    break;
                }
                default:
                {
                    break;
                }
            }
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark - Extracted methods
- (void)updateTableView
{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

@end
