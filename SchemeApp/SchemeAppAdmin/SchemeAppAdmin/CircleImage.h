//
//  CircleImages.h
//  SchemeAppAdmin
//
//  Created by Johan Thorell on 2013-10-02.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleImage : UIView
@property (nonatomic, copy) UIImage *image;
-(id)initWithImageForDetailView:(UIImage *)image rect:(CGRect)rect;
-(id)initWithImageForThumbnail:(UIImage *)image rect:(CGRect)rect;
@end
