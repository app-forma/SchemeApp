//
//  AdminCoursesViewController.m
//  SchemeApp
//
//  Created by Marcus Norling on 9/12/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminCoursesViewController.h"
#import "EventWrapperCell.h"

@interface AdminCoursesViewController ()

@end

@implementation AdminCoursesViewController

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
