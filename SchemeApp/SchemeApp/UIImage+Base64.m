//
//  UIImage+Base64.m
//  w8ctrlMobileAdmin
//
//  Created by Marcus Norling on 8/22/13.
//  Copyright (c) 2013 FrostyTouch. All rights reserved.
//

#import "UIImage+Base64.h"
#import "Base64.h"
@implementation UIImage (Base64)

+ (UIImage *)imageFromBase64:(NSString *)base64str
{
    NSURL *url = [NSURL URLWithString:base64str];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:imageData];
}

+ (NSString *)base64From:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
    return [imageData base64EncodedString];
}

@end
