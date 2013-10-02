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
        currentEvent = [self.delegate eventPopoverCurrentEvent];
        [self populateTextfieldsWithEvent:currentEvent forMethod:@"PUT"];
    } else {
        [self populateTextfieldsWithEvent:nil forMethod:@"POST"];
    }
}


-(void)populateTextfieldsWithEvent:(Event *)event forMethod:(NSString *)method
{
    if ([method isEqualToString:@"POST"]) {
        self.info.text = @"";
        self.room.text = @"";
        self.startDate.text = @"";
        self.endDate.text = @"";
    } else if ([method isEqualToString:@"PUT"]) {
        self.info.text = event.info;
        self.room.text = event.room;
        self.startDate.text = [Helpers stringFromNSDate:event.startDate];
        self.endDate.text = [Helpers stringFromNSDate:event.endDate];
    }
}

-(Event *)returnEventFromPopoverForCreate
{
    Event *event = [[Event alloc] initWithEventDictionary:@{@"info": self.info.text, @"room": self.room.text, @"startDate": self.startDate.text, @"endDate":self.endDate.text}];
    return event;
}

-(Event *)returnEventFromPopoverForUpdate
{
    Event *event = [[Event alloc] initWithEventDictionary:@{@"info": self.info.text, @"room": self.room.text, @"startDate": self.startDate.text, @"endDate":self.endDate.text, @"_id": currentEvent.docID}];
    return event;
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
