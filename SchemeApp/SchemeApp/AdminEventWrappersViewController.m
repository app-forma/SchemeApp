//
//  AdminCoursesViewController.m
//  SchemeApp
//
//  Created by Marcus Norling on 9/12/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminEventWrappersViewController.h"
#import "EventWrapperCell.h"
#import "AdminEventWrapperDetailsViewController.h"

@interface AdminEventWrappersViewController ()

@end

@implementation AdminEventWrappersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    if ([self.tabBarItem respondsToSelector:@selector(setFinishedSelectedImage:withFinishedUnselectedImage:)]) {
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"courses_selected"]];
    }
}

#pragma mark - Perpare for Segue / Set detailsView's details
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([@"AdminEventWrapperDetailsSegue" isEqualToString:segue.identifier])
    {
        AdminEventWrapperDetailsViewController *eventWrapperDetailsVC = segue.destinationViewController;
        eventWrapperDetailsVC.detailsCourseName = @"Some eventWrapper name";
        eventWrapperDetailsVC.detailsCourseStartDate = @"Some eventwrapper startDate";
        eventWrapperDetailsVC.detailsCourseEndDate = @"Some eventwrapper endDate";
        eventWrapperDetailsVC.detailsCourseTeacher = @"Some eventwrapper teacher";
        
        
        // WHEN USING STORE USE SOMETHING LIKE THIS!
        /*NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        DetailObject *detail = [self detailForIndexPath:path];
        [segue.destinationViewController setDetail:detail];*/
    }
}

#pragma mark - StatusBar
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventWrapperCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventWrapperCellIdentifier"];
    cell.eventWrapperName.text = @"Git crashcourse for retards";
    cell.eventWrapperStartDate.text = @"2013-10-01";
    cell.eventWrapperEndDate.text = @"2014-05-01";
    cell.eventWrapperOwnerName.text = @"Johan 1337 Thorell";
    
    return cell;
}
@end
