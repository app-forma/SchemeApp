//
//  SelectedEventWrapperEventsViewController.h
//  SchemeApp
//
//  Created by Marcus Norling on 9/19/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "SelectedEventTableViewController.h"
#import <UIKit/UIKit.h>

@class EventWrapper;


@interface SelectedEventWrapperEventsViewController : UITableViewController <SelectedEventViewControllerDelegate>

@property (nonatomic, strong) EventWrapper *selectedEventWrapper;

@end
