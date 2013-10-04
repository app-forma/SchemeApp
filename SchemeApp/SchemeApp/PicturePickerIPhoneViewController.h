//
//  PicturePickerViewController.h
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/30/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

@class PicturePickerViewController;
#import <UIKit/UIKit.h>

@class User;

@interface PicturePickerIPhoneViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

/**
 *  Set this when loading this vc if user already has a picture
 */
@property (nonatomic, strong) User *user;

@end
