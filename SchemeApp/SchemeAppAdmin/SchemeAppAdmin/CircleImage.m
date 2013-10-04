//
//  CircleImages.m
//  SchemeAppAdmin
//
//  Created by Johan Thorell on 2013-10-02.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import "CircleImage.h"

typedef enum Image{
    DetailImage,
    ThumbnailImage
}Image;

@interface CircleImage ()
@property (nonatomic) Image imageDef;
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation CircleImage

-(id)initWithImage:(UIImage *)image rect:(CGRect)rect imageDef:(Image)imageDef
{
    
    self = [super init];
    if (self) {
        self.frame = rect;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        self.imageDef = imageDef;
        self.imageView.image = image;
        self.imageView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
//        [self drawRect:self.frame];
    }
    return self;
}
-(id)initWithImageForThumbnail:(UIImage *)image rect:(CGRect)rect
{
    return [self initWithImage:image rect:rect imageDef:ThumbnailImage];
}
-(id)initWithImageForDetailView:(UIImage *)image rect:(CGRect)rect
{
    return [self initWithImage:image rect:rect imageDef:DetailImage];
}
-(void)drawRect:(CGRect)rect
{
    if (self.imageDef == DetailImage) {
        [self drawImageForDetailView:rect];
    }else if (self.imageDef == ThumbnailImage) {
        [self drawImageForThumbnail:rect];
    }
}
-(void)drawImageForDetailView:(CGRect)rect
{
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, rect.size.width, rect.size.height) cornerRadius:self.imageView.frame.size.height/2];
    CGFloat imageRatio = self.imageView.image.size.width / self.imageView.image.size.height;
    CGSize imageSize = CGSizeMake(rect.size.height * imageRatio, rect.size.height);
    CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    [path addClip];
    [self.imageView.image drawInRect:imageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = image;
    [self addSubview:self.imageView];
}
-(void)drawImageForThumbnail:(CGRect)rect
{
    
    int radius = rect.size.width;
    
    UIBezierPath* roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 10, rect.size.width-14, rect.size.height-14) cornerRadius:radius/2];
    [[UIColor whiteColor] setStroke];
    roundedRect.lineWidth = 3;
    [roundedRect stroke];
    

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(13, 13, rect.size.width-20, rect.size.height-20) cornerRadius:self.imageView.frame.size.height/2];
    CGFloat imageRatio = self.imageView.image.size.width / self.imageView.image.size.height;
    CGSize imageSize = CGSizeMake(rect.size.height * imageRatio, rect.size.height);
    CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    [path addClip];
    [self.imageView.image drawInRect:imageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = image;
    [self addSubview:self.imageView];

    
}
-(UIImage *)resizeImage:(UIImage*)image scaledToSize:(CGSize)newSize
{

    UIGraphicsBeginImageContextWithOptions(newSize, YES, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
@end
