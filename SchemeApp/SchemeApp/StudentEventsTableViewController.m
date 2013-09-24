//
//  StudentEventsTableViewController.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/11/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentEventsTableViewController.h"
#import "StudentEventDetailsViewController.h"
#import "Event.h"
#import "EventCell.h"
#import "EventWrapper.h"

@interface StudentEventsTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation StudentEventsTableViewController
{

}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Events";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; // returnera antalet eventWrappers för en student.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.eventsWithEventWrapper count]; // returnera antalet events för en student.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCell";
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Event *event = self.eventsWithEventWrapper[indexPath.row][@"event"];
    EventWrapper *eventWrapper = self.eventsWithEventWrapper[indexPath.row][@"eventWrapper"];
    cell.info.text = event.info;
    cell.courseName.text = eventWrapper.name;
    cell.date.text = [Helpers stringFromNSDate:event.startDate];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentEventDetailsViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentEventDetailsViewController"];
    
    detailView.eventWrapper = self.eventsWithEventWrapper[indexPath.row][@"eventWrapper"];
    detailView.event = self.eventsWithEventWrapper[indexPath.row][@"event"];
    
    [self.navigationController pushViewController:detailView animated:YES];
}

@end
