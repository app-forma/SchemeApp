//
//  UIButton+CustomButton.m
//  FTAwesomeMenu
//
//  Created by Marcus Norling on 9/2/13.
//  Copyright (c) 2013 FrostyTouch. All rights reserved.
//

#import "UIButton+CustomButton.h"

@implementation UIButton (CustomButton)

+ (UIButton *)customButtonWithIconImage:(UIImage *)image tag:(NSUInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    button.userInteractionEnabled = YES;
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

@end
