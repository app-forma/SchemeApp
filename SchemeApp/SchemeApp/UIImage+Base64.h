//
//  UIImage+Base64.h
//  w8ctrlMobileAdmin
//
//  Created by Marcus Norling on 8/22/13.
//  Copyright (c) 2013 FrostyTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Base64)

+ (UIImage *)imageFromBase64:(NSString *)base64str;
+ (NSString *)base64From:(UIImage *)image;÷
@end
