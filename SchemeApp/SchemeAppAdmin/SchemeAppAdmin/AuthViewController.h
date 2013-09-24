//
//  AuthViewController.h
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/24/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuthDelegate <NSObject>

- (void)didSuccesfullyLogin;

@end

@interface AuthViewController : UIViewController

@property (weak) id <AuthDelegate> delegate;

@end
