//
//  StudentMessageDetailsViewController.h
//  SchemeApp
//
//  Created by Rikard Karlsson on 9/11/13.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentMessageDetailsViewController : UIViewController
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSDate *date;
@end
