//
//  DetailMessageViewController.h
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMessageViewController.h"

@interface DetailMessageViewController : UIViewController <UISplitViewControllerDelegate, MasterMessageDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end
