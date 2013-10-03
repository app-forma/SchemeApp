//
//  UIViewController+BarPositionTopBehaviour.m
//  SchemeAppAdmin
//
//  Created by Erik Österberg on 2013-10-03.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "UIViewController+BarPositionTopBehaviour.h"

@implementation UIViewController (BarPositionTopBehaviour)

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}


@end
