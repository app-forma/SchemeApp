//
//  AdminEventTableViewController.h
//  SchemeApp
//
//  Created by Henrik on 2013-09-19.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;


@interface AdminEventTableViewController : UITableViewController

@property (nonatomic, strong) Event *selectedEvent;
@property (nonatomic, strong) EventWrapper *selectedEventWrapper;
@property (nonatomic) BOOL isNew;

@end
