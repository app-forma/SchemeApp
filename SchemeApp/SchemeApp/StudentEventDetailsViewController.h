//
//  StudentEventDetailsViewController.h
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/11/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventWrapper.h"

@interface StudentEventDetailsViewController : UIViewController

@property (nonatomic, strong) EventWrapper *eventWrapper;
@property (nonatomic, strong) Event *event;

@end
