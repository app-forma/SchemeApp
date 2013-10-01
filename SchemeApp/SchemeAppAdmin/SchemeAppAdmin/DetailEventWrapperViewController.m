//
//  DetailEventWrapperViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "DetailEventWrapperViewController.h"
#import "EventWrapper.h"
#import "Event.h"
#import "UIButton+CustomButton.h"
#import "PopoverEventWrapperViewController.h"

#import "SelectedEventWrapperEventCell.h"

#import "AwesomeUI.h"


@interface DetailEventWrapperViewController () <PopoverEventWrapperDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIButton *editButton;
    UIPopoverController *eventWrapperInfoPopover;
    PopoverEventWrapperViewController *pewvc;
    EventWrapper *currentEventWrapper;
    NSMutableArray *events;
    UIView *coverView;
    
}
@property (weak, nonatomic) IBOutlet UILabel *eventWrapperName;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *litteratureLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITableView *eventsTableView;

@end

@implementation DetailEventWrapperViewController



- (IBAction)deleteEventWrapper:(id)sender
{
    NSLog(@"Delete this shit!");
}



- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    
    
}


- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
}
-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    pewvc = [[PopoverEventWrapperViewController alloc] init];
    pewvc.delegate = self;
    
    editButton = [UIButton customButtonWithIconImage:[UIImage imageNamed:@"editIcon"] tag:2];
    [editButton addTarget:self action:@selector(editEventWrapper:) forControlEvents:UIControlEventTouchUpInside];
    editButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:editButton];
    NSDictionary *views = NSDictionaryOfVariableBindings(editButton);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[editButton(50.0)]-(25.0)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(50.0)-[editButton(50.0)]" options:0 metrics:nil views:views]];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

/**
 *  Called by masterViewDelegate incase of no data
 */
- (void)setViewToEmptyState
{
    coverView = [[UIView alloc] init];
    coverView.translatesAutoresizingMaskIntoConstraints = NO;
    coverView.backgroundColor = [AwesomeUI backgroundColorForCoverViews];
    
    UILabel *noContentLabel = [[UILabel alloc] init];
    noContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    noContentLabel.text = @"You have no courses yet...";
    noContentLabel.font = [AwesomeUI fontForCoverViews];
    noContentLabel.textColor = [AwesomeUI fontColorForCoverViews];
    
    [self.view addSubview:coverView];
    [coverView addSubview:noContentLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(coverView, noContentLabel);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[coverView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[coverView]|" options:0 metrics:nil views:views]];
    
    [coverView addConstraint:[NSLayoutConstraint constraintWithItem:noContentLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:coverView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-4.0]];
    
    [coverView addConstraint:[NSLayoutConstraint constraintWithItem:noContentLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:coverView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
}

- (void)editEventWrapper:(id)sender
{
    [self showPopover:sender];
}

-(EventWrapper *)popoverEventWrapperCurrentEventWrapper
{
    return currentEventWrapper;
}

-(void)popoverEventWrapperUpdateEventWrapper:(EventWrapper *)eventWrapper
{
    
    void(^saveHandler)(void) = ^(void)
    {
        [NSOperationQueue.mainQueue addOperationWithBlock:^
         {
             [self.navigationController popViewControllerAnimated:YES];
         }];
    };
    

        [Store.adminStore updateEventWrapper:eventWrapper
                                  completion:^(id jsonObject, id response, NSError *error)
         {

             saveHandler();
         }];

    
   
    
    

}

-(void)showPopover:(id)sender
{
    pewvc.isInEditingMode = YES;
    eventWrapperInfoPopover = [[UIPopoverController alloc] initWithContentViewController:pewvc];
    UIButton *senderButton = (UIButton *)sender;
    [eventWrapperInfoPopover setPopoverContentSize:CGSizeMake(300, 290)];
    [eventWrapperInfoPopover presentPopoverFromRect:senderButton.bounds inView:senderButton permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

-(void)popoverEventWrapperDismissPopover
{
    [eventWrapperInfoPopover dismissPopoverAnimated:YES];
}

#pragma mark - MasterEventWrapper delegate

-(void)masterEventWrapperDidSelectEventWrapper:(EventWrapper *)eventWrapper
{
    [coverView removeFromSuperview];
    self.eventWrapperName.text = eventWrapper.name;
    self.navItem.title = eventWrapper.name;
    self.teacherLabel.text = [NSString  stringWithFormat:@"%@ %@", eventWrapper.user.firstname, eventWrapper.user.lastname];
    self.litteratureLabel.text = eventWrapper.litterature;
    self.startDateLabel.text = [Helpers stringFromNSDate:eventWrapper.startDate];
    self.endDateLabel.text = [Helpers stringFromNSDate:eventWrapper.endDate];
    currentEventWrapper = eventWrapper;
    events = [[NSMutableArray alloc] initWithArray:eventWrapper.events];
    NSLog(@"Events: %@", events);
}

- (void)masterEventWrapperHasNoData
{
    [self setViewToEmptyState];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Count: %d", [events count]);
    return [events count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedEventWrapperEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdminEventCell"];
    
    [self resetCell:cell];
    [self fetchEventForIndexPath:indexPath andLoadIntoCell:cell];
    
    return cell;
}


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
    NSLog(@"CURRENT EVENTWRAPPER: %@", currentEventWrapper.events[indexPath.row]);
    [Store.adminStore eventWithDocID:currentEventWrapper.events[indexPath.row]
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedEventWrapperEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdminEventCell"];
    
    [self resetCell:cell];
    [self fetchEventForIndexPath:indexPath
                 andLoadIntoCell:cell];
    
    return cell;
}*/



@end
