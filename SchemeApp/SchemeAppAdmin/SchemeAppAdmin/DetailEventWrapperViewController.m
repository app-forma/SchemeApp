//
//  DetailEventWrapperViewController.m
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "DetailEventWrapperViewController.h"
#import "EventWrapper.h"
#import "UIButton+CustomButton.h"
#import "PopoverEventWrapperViewController.h"

@interface DetailEventWrapperViewController () <PopoverEventWrapperDelegate>
{
    UIButton *editButton;
    UIPopoverController *eventWrapperInfoPopover;
    PopoverEventWrapperViewController *pewvc;
    EventWrapper *currentEventWrapper;
   
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
}




@end
