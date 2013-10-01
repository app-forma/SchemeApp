//
//  MasterEventWrapperViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "MasterEventWrapperViewController.h"
#import "EventWrapper.h"
#import "PopoverEventWrapperViewController.h"
#import "AppDelegate.h"
#import "AwesomeUI.h"

@interface MasterEventWrapperViewController () <UITableViewDelegate, PopoverEventWrapperDelegate>
{
    NSMutableArray *eventWrappers;
    UIPopoverController *addEventWrapperPopover;
    PopoverEventWrapperViewController *pewvc;
}

@property (weak, nonatomic) IBOutlet UITableView *eventWrappersTableView;

@end

@implementation MasterEventWrapperViewController

- (void)viewWillAppear:(BOOL)animated
{
    [Store.adminStore eventWrappersCompletion:^(NSArray *allEventWrappers)
     {
         eventWrappers = [NSMutableArray arrayWithArray:allEventWrappers];
         [NSOperationQueue.mainQueue addOperationWithBlock:^
          {
              [self.eventWrappersTableView reloadData];
              NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
              if ([allEventWrappers count]) {
                  [self.eventWrappersTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                  [self tableView:self.eventWrappersTableView didSelectRowAtIndexPath:indexPath];
              } else {
                  
                  /**
                   *    DESIGN UTKAST!
                   */
                  self.tableView.backgroundColor = [AwesomeUI backgroundColorForEmptyTableView];
                  self.view.backgroundColor = [AwesomeUI backgroundColorForEmptyTableView];
                  [self.delegate masterEventWrapperHasNoData];
              }
          }];
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    pewvc = [[PopoverEventWrapperViewController alloc] init];
    pewvc.delegate = self;
    /**
     *    DESIGN UTKAST!
     */
    [AwesomeUI setGGstyleTo:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventWrappers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    EventWrapper *eventWrapper = eventWrappers[indexPath.row];
    cell.textLabel.text = eventWrapper.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate masterEventWrapperDidSelectEventWrapper:eventWrappers[indexPath.row]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *url = [NSString stringWithFormat:@"%@/%@", DB_TYPE_EVENTWRAPPER, [eventWrappers[indexPath.row]docID]];
        [[Store dbSessionConnection] deletePath:url withCompletion:^(id jsonObject, id response, NSError *error) {
            [self.eventWrappersTableView reloadData];
        }];
        [eventWrappers removeObject:eventWrappers[indexPath.row]];
        [self.eventWrappersTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        if (![eventWrappers count]) {
            [self.delegate masterEventWrapperHasNoData];
        }
    }
}

- (IBAction)addEventWrapper:(id)sender
{
    [self showPopover:sender];
}

-(void)showPopover:(id)sender
{
    //to avoid crash if it already showing:
    if (addEventWrapperPopover.popoverVisible) {
        return [addEventWrapperPopover dismissPopoverAnimated:YES];
    }
    
    pewvc.isInEditingMode = NO;
    
    addEventWrapperPopover = [[UIPopoverController alloc] initWithContentViewController:pewvc];
    [addEventWrapperPopover setPopoverContentSize:CGSizeMake(300, 290)];
    [addEventWrapperPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)popoverEventWrapperDismissPopover
{
    [addEventWrapperPopover dismissPopoverAnimated:YES];
}
-(void)popoverEventWrapperCreateEventWrapper:(EventWrapper *)eventWrapper
{
    void(^saveHandler)(void) = ^(void)
    {
        [NSOperationQueue.mainQueue addOperationWithBlock:^
         {
             [self.navigationController popViewControllerAnimated:YES];
         }];
    };
    [Store.adminStore createEventWrapper:eventWrapper completion:^(id jsonObject, id response, NSError *error)
     {

         saveHandler();
         [Store.adminStore eventWrappersCompletion:^(NSArray *allEventWrappers)
          {
              eventWrappers = [NSMutableArray arrayWithArray:allEventWrappers];
              [NSOperationQueue.mainQueue addOperationWithBlock:^
               {
                   [self.eventWrappersTableView reloadData];
                   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[eventWrappers count] - 1 inSection:0];
                   [self.eventWrappersTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                   [self tableView:self.eventWrappersTableView didSelectRowAtIndexPath:indexPath];
               }];
          }];
     }];
}
@end
