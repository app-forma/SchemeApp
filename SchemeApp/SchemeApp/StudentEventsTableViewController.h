//
//  StudentEventsTableViewController.h
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/11/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentEventsTableViewController : UITableViewController
@property (nonatomic, copy) NSString *course;
@property (nonatomic, copy) NSString *litterature;
@property (nonatomic, copy) NSString *dateForClass;
@property (nonatomic, copy) NSString *teacher;
@property (nonatomic, copy) NSString *startDateCourse;
@property (nonatomic, copy) NSString *endDateCourse;
@end
