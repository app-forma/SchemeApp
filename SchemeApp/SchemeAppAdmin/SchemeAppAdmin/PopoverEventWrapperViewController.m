//
//  PopoverEventWrapperViewController.m
//  SchemeAppAdmin
//
//  Created by Rikard Karlsson on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "PopoverEventWrapperViewController.h"
#import "DetailEventWrapperViewController.h"
#import "EventWrapper.h"

@interface PopoverEventWrapperViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *courseName;
@property (weak, nonatomic) IBOutlet UITextField *teacher;
@property (weak, nonatomic) IBOutlet UITextField *litterature;
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;

@end

@implementation PopoverEventWrapperViewController
{
    NSString *currentMethod;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.isInEditingMode) {
        EventWrapper *currentEventWrapper = [self.delegate currentEventWrapper];
        [self populateTextFieldsWith:currentEventWrapper for:@"PUT"];
    } else {
        [self populateTextFieldsWith:nil for:@"POST"];
    }
}

-(void)populateTextFieldsWith:(EventWrapper *)eventWrapper for:(NSString *)method
{
    if ([method isEqualToString:@"PUT"]) {
        self.courseName.text = eventWrapper.name;
        self.teacher.text = [NSString  stringWithFormat:@"%@ %@", eventWrapper.user.firstname, eventWrapper.user.lastname];
        self.litterature.text = eventWrapper.litterature;
        self.startDate.text = [Helpers stringFromNSDate:eventWrapper.startDate];
        self.endDate.text = [Helpers stringFromNSDate:eventWrapper.endDate];
    } else if ([method isEqualToString:@"POST"]) {
        self.courseName.text = @"";
        self.teacher.text = [NSString stringWithFormat:@"%@ %@", Store.mainStore.currentUser.firstname, Store.mainStore.currentUser.lastname];
        self.litterature.text = @"";
        self.startDate.text = @"";
        self.endDate.text = @"";

    }
}
-(EventWrapper *)returnEventWrapperFromPopover
{
    EventWrapper *eventWrapper = [EventWrapper new];
    eventWrapper.name = self.courseName.text;
    eventWrapper.user = Store.mainStore.currentUser;
    eventWrapper.litterature = self.litterature.text;
    eventWrapper.startDate = [Helpers dateFromString:self.startDate.text];
    eventWrapper.endDate = [Helpers dateFromString:self.endDate.text];
    return eventWrapper;
}
- (IBAction)saveEventWrapper:(id)sender
{

//    if (self.isInEditingMode) {
//        [self.delegate saveOrUpdateEventWrapper:[self returnEventWrapperFromPopover] for:@"PUT"];
//    } else {
//        [self.delegate saveOrUpdateEventWrapper:[self returnEventWrapperFromPopover] for:@"POST"];
//    }
   
    [self.delegate dismissPopover];

}

@end
