//
//  PicturePickerViewController.h
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/30/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

@class PicturePickerViewController;
@protocol PicturePickerDelegate <NSObject>

- (void)picturePicker:(PicturePickerViewController *)picturePicker didFinishPickingPicture:(UIImage *)image forUser:(User *)user;
- (void)picturePickerDidCancel;

@end

#import <UIKit/UIKit.h>

@class User;

@interface PicturePickerViewController : UIViewController

@property (weak) id <PicturePickerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;

/**
 *  Set this when loading this vc if user already has a picture
 */
@property (nonatomic, strong) User *user;

@end
