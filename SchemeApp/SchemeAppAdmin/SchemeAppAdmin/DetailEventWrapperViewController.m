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
#import "PopoverEventViewController.h"
#import "IpadEventCell.h"
#import "AwesomeUI.h"


@interface DetailEventWrapperViewController () <PopoverEventWrapperDelegate, PopoverEventDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIButton *editButton;
    
    UIPopoverController *eventWrapperInfoPopover;
    PopoverEventWrapperViewController *pewvc;
    EventWrapper *currentEventWrapper;
    
    UIPopoverController *eventInfoPopover;
    PopoverEventViewController *pevc;
    Event *currentEvent;
    NSIndexPath *selectedIndexPath;
    
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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolbarTitle;

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
    
    self.toolbarTitle.enabled = FALSE;
    
    UINib *nib = [UINib nibWithNibName:@"IpadEventCell" bundle:nil];
    [self.eventsTableView registerNib:nib forCellReuseIdentifier:@"IpadEventCell"];
    
    pewvc = [[PopoverEventWrapperViewController alloc] init];
    pewvc.delegate = self;
    
    pevc = [[PopoverEventViewController alloc] init];
    pevc.delegate = self;
    
    editButton = [UIButton customButtonWithIconImage:[UIImage imageNamed:@"editIcon"] tag:2];
    [editButton addTarget:self action:@selector(editEventWrapper:) forControlEvents:UIControlEventTouchUpInside];
    editButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:editButton];
    NSDictionary *views = NSDictionaryOfVariableBindings(editButton);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[editButton(50.0)]-(15.0)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(70.0)-[editButton(50.0)]" options:0 metrics:nil views:views]];
    events = [[NSMutableArray alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0;
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
    [self.eventsTableView reloadData];
}


- (void)masterEventWrapperHasNoData
{
    [self setViewToEmptyState];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [events count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IpadEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IpadEventCell" forIndexPath:indexPath];
    
    [Store.adminStore eventWithDocID:currentEventWrapper.events[indexPath.row]
                          completion:^(Event *event)
     {
         events[indexPath.row] = event;
         
         [NSOperationQueue.mainQueue addOperationWithBlock:^
          {
              cell.info.text = event.info;
              cell.date.text = [NSString stringWithFormat:@"%@ - %@", [Helpers stringFromNSDate:event.startDate], [Helpers stringFromNSDate:event.endDate]];
              cell.room.text = [NSString stringWithFormat:@"Room: %@", event.room];
          }];
     }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Event *selectedEvent = events[indexPath.row];
        [self removeEventWithIndexPath:indexPath];
        
        [Store.adminStore updateEventWrapper:currentEventWrapper
                                  completion:^(id jsonObject, id response, NSError *error)
         {
             if (error)
             {
                 NSLog(@"[%@] updateEventWrapper got respone: %@ and error: %@", self.class, response, error.userInfo);
                 
                 [NSOperationQueue.mainQueue addOperationWithBlock:^
                  {
                      [self.eventsTableView reloadData];
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

- (void)removeEventWithIndexPath:(NSIndexPath *)indexPath
{
    [currentEventWrapper.events removeObjectAtIndex:indexPath.row];
    [events removeObjectAtIndex:indexPath.row];
    
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^
     {
         [self.eventsTableView deleteRowsAtIndexPaths:@[indexPath]
                               withRowAnimation:UITableViewRowAnimationFade];
     }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
    pevc.eventIsInEditingMode = YES;
    currentEvent = events[indexPath.row];
    [self showEventPopover:nil];
}

-(Event *)eventPopoverCurrentEvent
{
    return currentEvent;
}

- (IBAction)addEvent:(id)sender
{
    pevc.eventIsInEditingMode = NO;
    [self showEventPopover:sender];
}

-(void)showEventPopover:(id)sender
{
    if (eventInfoPopover.isPopoverVisible) {
        return [eventInfoPopover dismissPopoverAnimated:YES];
    }
    eventInfoPopover = [[UIPopoverController alloc] initWithContentViewController:pevc];
    [eventInfoPopover setPopoverContentSize:CGSizeMake(300, 310)];
    
    if (pevc.eventIsInEditingMode) {
        [eventInfoPopover presentPopoverFromRect:CGRectMake(0, 0, 320, 1) inView:self.eventsTableView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        [eventInfoPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    
}

-(void)dismissEventPopover
{
    [eventInfoPopover dismissPopoverAnimated:YES];
}

-(void)eventPopoverCreateEvent:(Event *)event
{
    [Store.adminStore createEvent:event
                       completion:^(id jsonObject, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"save: got response: %@ and error: %@", response, error.userInfo);
         }
         else
         {
             [self didAddEvent:[[Event alloc] initWithEventDictionary:jsonObject]];
         }
     }];
}

-(void)eventPopoverUpdateEvent:(Event *)event
{
    [Store.adminStore updateEvent:event
                       completion:^(id jsonObject, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"save: got response: %@ and error: %@", response, error);
         }
         else
         {
             [self didEditEvent:event];
         }
     }];
}

- (void)didAddEvent:(Event *)event
{
    [self addEventToEventWrapper:event];
    
    [Store.adminStore updateEventWrapper:currentEventWrapper
                              completion:^(id jsonObject, id response, NSError *error)
     {
         if (error)
         {
             NSLog(@"[%@] didAddEvent got response: %@ and error: %@", self.class, response, error.userInfo);
         }
     }];
}

-(void)addEventToEventWrapper:(Event *)event
{
    [currentEventWrapper.events addObject:event.docID];
    [events addObject:event.docID];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^
     {
         [self.eventsTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:events.count - 1 inSection:0]]
                                     withRowAnimation:UITableViewRowAnimationAutomatic];
     }];
}

-(void)didEditEvent:(Event *)event
{
    [NSOperationQueue.mainQueue addOperationWithBlock:^
     {
         [self.eventsTableView reloadRowsAtIndexPaths:@[selectedIndexPath]
                               withRowAnimation:UITableViewRowAnimationAutomatic];
     }];
}


@end
