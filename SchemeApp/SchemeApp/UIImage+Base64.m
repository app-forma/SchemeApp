//
//  UIImage+Base64.m
//  w8ctrlMobileAdmin
//
//  Created by Marcus Norling on 8/22/13.
//  Copyright (c) 2013 FrostyTouch. All rights reserved.
//

#import "UIImage+Base64.h"

@implementation UIImage (Base64)

+ (UIImage *)imageFromBase64:(NSString *)base64str
{
    NSData *imageDataFromBase64String = [[NSData alloc]initWithBase64EncodedString:base64str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:imageDataFromBase64String];
}

+ (NSString *)base64From:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
    return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
