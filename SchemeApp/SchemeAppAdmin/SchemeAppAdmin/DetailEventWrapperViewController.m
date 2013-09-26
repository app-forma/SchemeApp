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
    UIButton *addButton;
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

@end

@implementation DetailEventWrapperViewController


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
    /*
    addButton = [UIButton customButtonWithIconImage:[UIImage imageNamed:@"newIcon"] tag:1];
    [addButton addTarget:self action:@selector(addNewEventWrapper:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setFrame:CGRectMake(500, 24, 50, 50)];
    [self.view addSubview:addButton];*/
    
    editButton = [UIButton customButtonWithIconImage:[UIImage imageNamed:@"editIcon"] tag:2];
    [editButton addTarget:self action:@selector(editEventWrapper:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setFrame:CGRectMake(338, 40, 50, 50)];
    [self.view addSubview:editButton];
}

- (void)editEventWrapper:(id)sender
{
    [self showPopover:sender];
}

-(EventWrapper *)currentEventWrapper
{
    return currentEventWrapper;
}

-(void)showPopover:(id)sender
{
    
    pewvc.isInEditingMode = YES;
    
    eventWrapperInfoPopover = [[UIPopoverController alloc] initWithContentViewController:pewvc];
    UIButton *senderButton = (UIButton *)sender;
    [eventWrapperInfoPopover setPopoverContentSize:CGSizeMake(300, 400)];
    [eventWrapperInfoPopover presentPopoverFromRect:senderButton.bounds inView:senderButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)dismissPopover
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
    self.teacherLabel.text = [NSString  stringWithFormat:@"%@ %@", eventWrapper.user.firstname, eventWrapper.user.lastname];
    self.litteratureLabel.text = eventWrapper.litterature;
    self.startDateLabel.text = [Helpers stringFromNSDate:eventWrapper.startDate];
    self.endDateLabel.text = [Helpers stringFromNSDate:eventWrapper.endDate];
    currentEventWrapper = eventWrapper;
}




@end
