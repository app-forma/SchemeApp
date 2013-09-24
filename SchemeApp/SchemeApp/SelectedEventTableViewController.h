//
//  SelectedEventTableViewController.h
//  SchemeApp
//
//  Created by Henrik on 2013-09-19.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event, EventWrapper;


@interface SelectedEventTableViewController : UITableViewController

@property (nonatomic, strong) Event *selectedEvent;
@property (nonatomic, strong) EventWrapper *selectedEventWrapper;
@property (nonatomic) BOOL isNew;

@property (nonatomic, assign) id delegate;

@end


@protocol SelectedEventViewControllerDelegate <NSObject>

- (void)didAddEvent:(Event *)event;
- (void)didEditEvent:(Event *)event;

@end
