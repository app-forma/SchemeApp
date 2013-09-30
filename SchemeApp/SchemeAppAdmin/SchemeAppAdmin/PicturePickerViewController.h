//
//  PicturePickerViewController.h
//  SchemeAppAdmin
//
//  Created by Marcus Norling on 9/30/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

@protocol PicturePickerDelegate <NSObject>

- (void)picturePickerDidFinishPickingPicture:(UIImage *)image;
- (void)picturePickerDidCancel;

@end

#import <UIKit/UIKit.h>

@interface PicturePickerViewController : UIViewController

@property (weak) id <PicturePickerDelegate> delegate;

/**
 *  Set this when loading this vc if user already has a picture
 */
@property (nonatomic, strong) UIImage *image;

@end
