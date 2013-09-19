//
//  AdminEditStudentViewController.h
//  SchemeApp
//
//  Created by Henrik on 2013-09-16.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;


@interface AdminEditStudentViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) User *selectedUser;

@end
