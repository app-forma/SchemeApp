//
//  StudentWhatToReadMainViewController.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/24/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentWhatToReadTableViewController.h"
#import "User.h"
#import "EventWrapper.h"
#import "Event.h"
#import "WhatToReadCell.h"
#import "AwesomeUI.h"

@interface StudentWhatToReadTableViewController ()
@end

@implementation StudentWhatToReadTableViewController
{
    NSArray *todaysLessons;
    NSArray *thisWeeksLessons;
    
    BOOL weekMode;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AwesomeUI setGGstyleTo:self.tableView];
    self.tableView.backgroundColor = [AwesomeUI backgroundColorForEmptyTableView];
    self.navigationItem.title = @"Guidance";
    
    todaysLessons = [self getLessonsForToday];
    thisWeeksLessons = [self getLessonsForTheWeek];
}

- (NSArray*)getLessonsForToday
{
    NSDictionary *today = [Helpers startAndEndTimeForDate:[NSDate date]];
    return [self filteredDatesForWhatToRead:@{@"startDate": [Helpers dateFromString:today[@"startTime"]], @"endDate": [Helpers dateFromString:today[@"endTime"]]}];
}

- (NSArray*)getLessonsForTheWeek
{
    NSDictionary *week = [Helpers startAndEndDateOfWeekForDate:[NSDate date]];
    return [self filteredDatesForWhatToRead:@{@"startDate": [Helpers dateFromString:week[@"startDate"]], @"endDate": [Helpers dateFromString:week[@"endDate"]]}];
}

-(NSArray *)filteredDatesForWhatToRead:(NSDictionary *)dateDic
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

- (IBAction)didChangeControl:(UISegmentedControl *)sender {
    weekMode = sender.selectedSegmentIndex == 1 ? YES : NO;
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return weekMode ? thisWeeksLessons.count : todaysLessons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WhatToReadCell";
    WhatToReadCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [AwesomeUI addColorAndDefaultStyleTo:cell forIndexPath:indexPath];
    
    NSArray *dataSource = weekMode ? thisWeeksLessons : todaysLessons;
    
    EventWrapper *eventWrapper = dataSource[indexPath.row][@"eventWrapper"];
    Event *event = dataSource[indexPath.row][@"event"];
    
    cell.courseLabel.text = eventWrapper.name;
    cell.dateLabel.text = [Helpers stringFromNSDate:event.startDate];
    cell.whatToReadTextField.text = event.info;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}



@end
