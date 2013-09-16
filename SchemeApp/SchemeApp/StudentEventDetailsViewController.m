//
//  StudentEventDetailsViewController.m
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/11/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "StudentEventDetailsViewController.h"
@interface StudentEventDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *classDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;


@end

@implementation StudentEventDetailsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


// En vy med details för det valda eventet av studenten.



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.courseLabel.text = self.eventWrapper.name;
    self.teacherLabel.text = [NSString stringWithFormat:@"%@ %@", self.eventWrapper.user.firstname, self.eventWrapper.user.lastname];
    self.courseDateLabel.text = [NSString stringWithFormat:@"%@ - %@",[Helpers stringFromNSDate:self.eventWrapper.startDate], [Helpers stringFromNSDate:self.eventWrapper.endDate]];
    self.classDateLabel.text = [NSString stringWithFormat:@"%@",[Helpers stringFromNSDate:self.event.startDate]];
    self.infoTextView.text = self.event.info;
}

@end
