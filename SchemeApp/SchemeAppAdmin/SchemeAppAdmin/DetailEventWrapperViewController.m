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
#import "AwesomeUI.h"

@interface DetailEventWrapperViewController () <PopoverEventWrapperDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIButton *editButton;
    UIPopoverController *eventWrapperInfoPopover;
    PopoverEventWrapperViewController *pewvc;
    EventWrapper *currentEventWrapper;
    NSMutableArray *events;
   
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
    
    /**
     *    DESIGN UTKAST!
     *    Se vad metoden gör
     */
    [self isViewEmpty];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    editButton = [UIButton customButtonWithIconImage:[UIImage imageNamed:@"editIcon"] tag:2];
    [editButton addTarget:self action:@selector(editEventWrapper:) forControlEvents:UIControlEventTouchUpInside];
    editButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:editButton];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(editButton);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[editButton(50.0)]-(25.0)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(50.0)-[editButton(50.0)]" options:0 metrics:nil views:views]];
}

/**
 *  Checks if view has no data. If no it adds a view over the detail xib view saying "you got no x"
 */
- (void)isViewEmpty
{
    if ([self.teacherLabel.text isEqualToString:@"Label"] || !self.teacherLabel.text) {
        UIView *coverView = [[UIView alloc] init];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)masterEventWrapperDidSelectEventWrapper:(EventWrapper *)eventWrapper
{
    self.eventWrapperName.text = eventWrapper.name;
    self.navItem.title = eventWrapper.name;
    self.teacherLabel.text = [NSString  stringWithFormat:@"%@ %@", eventWrapper.user.firstname, eventWrapper.user.lastname];
    self.litteratureLabel.text = eventWrapper.litterature;
    self.startDateLabel.text = [Helpers stringFromNSDate:eventWrapper.startDate];
    self.endDateLabel.text = [Helpers stringFromNSDate:eventWrapper.endDate];
    currentEventWrapper = eventWrapper;
    events = [[NSMutableArray alloc] initWithArray:eventWrapper.events];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [events count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Event *event = [events objectAtIndex:indexPath.row];
    cell.textLabel.text = event.info;
    
    return cell;
}




@end
