//
//  AppDelegate.h
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/24/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, AuthDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
