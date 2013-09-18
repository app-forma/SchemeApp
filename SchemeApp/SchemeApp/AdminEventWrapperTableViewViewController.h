//
//  AdminEventWrapperTableViewViewController.h
//  SchemeApp
//
//  Created by Henrik on 2013-09-17.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventWrapper;


@interface AdminEventWrapperTableViewViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) EventWrapper *selectedEventWrapper;

@end
