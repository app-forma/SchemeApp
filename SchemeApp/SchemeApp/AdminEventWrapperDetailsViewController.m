//
//  AdminEventWrapperDetailsViewController.m
//  SchemeApp
//
//  Created by Marcus Norling on 9/12/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "AdminEventWrapperDetailsViewController.h"

@interface AdminEventWrapperDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTeacher;
@property (weak, nonatomic) IBOutlet UILabel *courseLitterature;
@property (weak, nonatomic) IBOutlet UILabel *courseStartDate;
@property (weak, nonatomic) IBOutlet UILabel *courseEndDate;

@end

@implementation AdminEventWrapperDetailsViewController

-(void)loadView
{
    [super loadView];
    
    // When in details view diable tabar. Use will use back button to get back
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.courseNameLabel.text = self.detailsCourseName;
    self.courseTeacher.text = self.detailsCourseTeacher;
    self.courseLitterature.text = self.detailsCourseLitterature;
    self.courseStartDate.text = self.detailsCourseStartDate;
    self.courseEndDate.text = self.detailsCourseEndDate;
}
@end
