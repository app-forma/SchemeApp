//
//  PopoverEventViewController.m
//  SchemeAppAdmin
//
//  Created by Rikard Karlsson on 10/2/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "PopoverEventViewController.h"
#import "Event.h"

@interface PopoverEventViewController ()
@property (weak, nonatomic) IBOutlet UITextView *info;
@property (weak, nonatomic) IBOutlet UITextField *room;
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;

@end

@implementation PopoverEventViewController
{
    Event *currentEvent;
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
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.eventIsInEditingMode) {
        [self populateTextfieldsWithEvent:[self.delegate eventPopoverCurrentEvent] forMethod:@"PUT"];
    } else {
        [self populateTextfieldsWithEvent:nil forMethod:@"POST"];
    }
}


-(void)populateTextfieldsWithEvent:(Event *)event forMethod:(NSString *)method
{
    if ([method isEqualToString:@"POST"]) {
        NSLog(@"POST");
    } else if ([method isEqualToString:@"PUT"]) {
        NSLog(@"PUT");
        NSLog(@"Current event. %@", event);
    }
}


-(Event *)returnEventFromPopoverForCreate
{
    return nil;
}

-(Event *)returnEventFromPopoverForUpdate
{
    return nil;
}

- (IBAction)saveEvent:(id)sender
{
    if (self.eventIsInEditingMode) {
        [self.delegate eventPopoverUpdateEvent:[self returnEventFromPopoverForUpdate]];
    } else {
        [self.delegate eventPopoverCreateEvent:[self returnEventFromPopoverForCreate]];
    }
    
    [self.delegate dismissEventPopover];
}

@end
