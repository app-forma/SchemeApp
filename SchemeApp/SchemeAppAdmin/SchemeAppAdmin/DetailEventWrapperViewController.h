//
//  DetailEventWrapperViewController.h
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterEventWrapperViewController.h"

@class EventWrapper;

@interface DetailEventWrapperViewController : UIViewController<MasterEventWrapperDelegate>

@property (weak, nonatomic) EventWrapper *selectedEventWrapper;


@end
