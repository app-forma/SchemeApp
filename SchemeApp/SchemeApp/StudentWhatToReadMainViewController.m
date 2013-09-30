//
//  StudentWhatToReadMainViewController.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/24/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentWhatToReadMainViewController.h"
#import "StudentWhatToReadTableViewController.h"
#import "User.h"
#import "EventWrapper.h"
#import "Event.h"

@interface StudentWhatToReadMainViewController ()

@end

@implementation StudentWhatToReadMainViewController

- (void)viewDidLoad
{
    self.navigationItem.title = @"Click";
    [super viewDidLoad];
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"glasses_selected.png"]];
    self.navigationItem.title = @"Guidance";
}


- (IBAction)getWhatToReadForToday:(id)sender
{
    
    NSDictionary *today = [Helpers startAndEndTimeForDate:[NSDate date]];
    [self getWhatToRead:@{@"startDate": [Helpers dateFromString:today[@"startTime"]], @"endDate": [Helpers dateFromString:today[@"endTime"]]}];
}


- (IBAction)getWhatToReadForTheWeek:(id)sender
{
    NSDictionary *week = [Helpers startAndEndDateOfWeekForDate:[NSDate date]];
    [self getWhatToRead:@{@"startDate": [Helpers dateFromString:week[@"startDate"]], @"endDate": [Helpers dateFromString:week[@"endDate"]]}];
}


-(void)getWhatToRead:(NSDictionary *)dateDic
{
    StudentWhatToReadTableViewController *swtrtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentWhatToReadTableViewController"];
    swtrtvc.whatToReadWithEventWrapper = [self filteredDatesForWhatToRead:dateDic];
    [self.navigationController pushViewController:swtrtvc animated:YES];
}


-(NSMutableArray *)filteredDatesForWhatToRead:(NSDictionary *)dateDic
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

@end
