//
//  DatePickerViewController.h
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/12/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *donePickingDateButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
