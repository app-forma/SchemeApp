//
//  AdminEventsViewController.m
//  SchemeApp
//
//  Created by Marcus Norling on 9/19/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminEventsViewController.h"
#import "AdminEventCell.h"
#import "AdminEventTableViewController.h"
#import "Event.h"
#import "EventWrapper.h"

@implementation AdminEventsViewController
{
    BOOL editingEvent;
    Event *selectedEvent;
}

- (void)viewDidLoad
{
    editingEvent = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    if (editingEvent)
    {
        [self.tableView reloadData];
        editingEvent = NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
#warning Refactor
    AdminEventTableViewController *vc = segue.destinationViewController;
    editingEvent = YES;
    
    if ([segue.identifier isEqualToString:@"AddEvent"])
    {
        vc.isNew = YES;
    }
    else if ([segue.identifier isEqualToString:@"EditEvent"])
    {
        vc.selectedEvent = selectedEvent;
        vc.isNew = NO;
    }
    
    vc.selectedEventWrapper = self.selectedEventWrapper;
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectedEventWrapper.events.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdminEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdminEventCell"];
    Event *event = self.selectedEventWrapper.events[indexPath.row];
    
    cell.info.text = event.info;
    cell.room.text = event.room;
    cell.startDate.text = [Helpers stringFromNSDate:event.startDate];
    cell.endDate.text = [Helpers stringFromNSDate:event.endDate];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedEvent = self.selectedEventWrapper.events[indexPath.row];
}

@end
