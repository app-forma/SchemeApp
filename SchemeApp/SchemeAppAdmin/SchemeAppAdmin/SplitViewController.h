//
//  SplitViewController.h
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplitViewController : UISplitViewController
@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIViewController *rightViewController;

-(id)initWithLeftVC:(UIViewController *)leftVC rightVC:(UIViewController *)rightVC;
@end
