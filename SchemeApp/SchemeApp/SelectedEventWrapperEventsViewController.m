//
//  SelectedEventWrapperEventsViewController.m
//  SchemeApp
//
//  Created by Marcus Norling on 9/19/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "SelectedEventWrapperEventsViewController.h"
#import "SelectedEventWrapperEventCell.h"
#import "SelectedEventTableViewController.h"
#import "Event.h"
#import "EventWrapper.h"


@implementation SelectedEventWrapperEventsViewController
{
    NSIndexPath *selectedIndexPath;
    NSMutableArray *events;
}

- (void)viewDidLoad
{
    events = self.selectedEventWrapper.events.mutableCopy;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SelectedEventTableViewController *vc = segue.destinationViewController;
    
    vc.delegate = self;
    vc.selectedEventWrapper = self.selectedEventWrapper;
    
    if ([segue.identifier isEqualToString:@"AddEvent"])
    {
        vc.isNew = YES;
    }
    else if ([segue.identifier isEqualToString:@"EditEvent"])
    {
        vc.isNew = NO;
        vc.selectedEvent = events[selectedIndexPath.row];
    }
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedEventWrapperEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdminEventCell"];
    
    [self resetCell:cell];
    [self fetchEventForIndexPath:indexPath
                 andLoadIntoCell:cell];
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Event *selectedEvent = events[indexPath.row];
        [self removeEventWithIndexPath:indexPath];
        
        [Store.adminStore updateEventWrapper:self.selectedEventWrapper
                                  completion:^(id jsonObject, id response, NSError *error)
        {
            if (error)
            {
#warning Present error to user
                NSLog(@"[%@] updateEventWrapper got respone: %@ and error: %@", self.class, response, error.userInfo);
                
                [NSOperationQueue.mainQueue addOperationWithBlock:^
                {
                    [self.tableView reloadData];
                }];
            }
            else
            {
                [Store.adminStore deleteEvent:selectedEvent
                                   completion:^(id jsonObject, id response, NSError *error)
                 {
                     if (error)
                     {
                          NSLog(@"[%@] deleteEvent got respone: %@ and error: %@", self.class, response, error.userInfo);
                     }
                 }];
            }
        }];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
}

#pragma mark - AdminEventTableViewControllerDelegate
- (void)didAddEvent:(Event *)event
{
    [self addEvent:event];
    
    [Store.adminStore updateEventWrapper:self.selectedEventWrapper
                              completion:^(id jsonObject, id response, NSError *error)
    {
        if (error)
        {
            NSLog(@"[%@] didAddEvent got response: %@ and error: %@", self.class, response, error.userInfo);
        }
    }];
}
- (void)didEditEvent:(Event *)event
{
    [NSOperationQueue.mainQueue addOperationWithBlock:^
    {
        [self.tableView reloadRowsAtIndexPaths:@[selectedIndexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

#pragma mark - Extracted methods
#pragma mark Cell
- (void)resetCell:(SelectedEventWrapperEventCell *)cell
{
    [cell.activityIndicator startAnimating];
    
    cell.loadedContentView.hidden = YES;
    cell.userInteractionEnabled = NO;
    cell.activityIndicator.hidden = NO;
}
- (void)showLoadedContentInCell:(SelectedEventWrapperEventCell *)cell
{
    cell.loadedContentView.hidden = NO;
    cell.userInteractionEnabled = YES;
    
    [cell.activityIndicator stopAnimating];
}
- (void)fetchEventForIndexPath:(NSIndexPath *)indexPath andLoadIntoCell:(SelectedEventWrapperEventCell *)cell
{
    [Store.adminStore eventWithDocID:self.selectedEventWrapper.events[indexPath.row]
                          completion:^(Event *event)
     {
         events[indexPath.row] = event;
         
         [NSOperationQueue.mainQueue addOperationWithBlock:^
          {
              cell.info.text = event.info;
              cell.room.text = event.room;
              cell.startDate.text = [Helpers stringFromNSDate:event.startDate];
              cell.endDate.text = [Helpers stringFromNSDate:event.endDate];
              
              [self showLoadedContentInCell:cell];
          }];
     }];
}
#pragma mark Adding and removing events
- (void)addEvent:(Event *)event
{
    [self.selectedEventWrapper.events addObject:event.docID];
    [events addObject:event.docID];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^
     {
         [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:events.count - 1 inSection:0]]
                               withRowAnimation:UITableViewRowAnimationAutomatic];
     }];
}

- (void)removeEventWithIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedEventWrapper.events removeObjectAtIndex:indexPath.row];
    [events removeObjectAtIndex:indexPath.row];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^
    {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }];
}

@end
