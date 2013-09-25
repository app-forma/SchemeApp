//
//  MasterEventWrapperViewController.h
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventWrapper;

@protocol MasterEventWrapperDelegate <NSObject>

- (void)masterEventWrapperDidSelectEventWrapper:(EventWrapper*)eventWrapper;

@end


@interface MasterEventWrapperViewController : UITableViewController

@property (weak) id <MasterEventWrapperDelegate> delegate;

@end
