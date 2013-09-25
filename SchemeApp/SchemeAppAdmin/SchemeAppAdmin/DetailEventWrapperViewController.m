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

@interface DetailEventWrapperViewController ()
{
    UIButton *addButton;
    UIButton *editButton;
}
@property (weak, nonatomic) IBOutlet UILabel *eventWrapperName;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *litteratureLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@end

@implementation DetailEventWrapperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    addButton = [UIButton customButtonWithIconImage:[UIImage imageNamed:@"newIcon"] tag:1];
    [addButton addTarget:self action:@selector(addNewEventWrapper:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setFrame:CGRectMake(500, 24, 50, 50)];
    [self.view addSubview:addButton];
    
    editButton = [UIButton customButtonWithIconImage:[UIImage imageNamed:@"editIcon"] tag:2];
    [editButton addTarget:self action:@selector(editEventWrapper:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setFrame:CGRectMake(600, 20, 50, 50)];
    [self.view addSubview:editButton];
}

- (void)addNewEventWrapper:(id)sender
{
    NSLog(@"123123123");
}

- (void)editEventWrapper:(id)sender
{
    NSLog(@"asdasd");
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
}
@end
