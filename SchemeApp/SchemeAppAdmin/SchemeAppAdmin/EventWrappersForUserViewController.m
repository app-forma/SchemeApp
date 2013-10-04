//
//  EventWrappersForUserViewController.m
//  SchemeAppAdmin
//
//  Created by Erik Österberg on 2013-10-04.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "EventWrappersForUserViewController.h"
#import "EventWrapper.h"


@interface EventWrappersForUserViewController ()

@end

@implementation EventWrappersForUserViewController
{
    User *user;
    NSArray *eventWrappers;
}


- (id)initWithUser:(User*)aUser eventWrappers:(NSArray *)eventWrappersForAdmin
{
    self = [super init];
    if (self) {
        user = aUser;
        eventWrappers = eventWrappersForAdmin;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return eventWrappers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    EventWrapper *course = eventWrappers[indexPath.row];
    
    cell.textLabel.text = course.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ to %@", course.startDate.asDateString, course.endDate.asDateString];
    cell.accessoryType = [self userHasCourse:course] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventWrapper *thisEventWrapper = eventWrappers[indexPath.row];
    
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    if (thisCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [[Store adminStore]removeEventWrapper:thisEventWrapper fromUser:user completion:^(BOOL success) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    thisCell.accessoryType = UITableViewCellAccessoryNone;
                });
                [user.eventWrappers removeObject:thisEventWrapper.docID];
            }
        }];
    } else {
        [[Store adminStore]addEventWrapper:thisEventWrapper toUser:user completion:^(BOOL success) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
                });
                [user.eventWrappers addObject:thisEventWrapper.docID];
            }
        }];
    }
}

- (BOOL)userHasCourse:(EventWrapper *)course {
    for (NSString *userCourseID in user.eventWrappers) {
        if ([userCourseID isEqualToString:course.docID]) {
            return YES;
        }
    }
    return NO;
}


@end
