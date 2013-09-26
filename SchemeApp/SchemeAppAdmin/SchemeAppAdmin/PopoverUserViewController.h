//
//  PopoverUserViewController.h
//  SchemeAppAdmin
//
//  Created by Johan Thorell on 2013-09-26.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PopoverUserDelegate <NSObject>
-(void)dismissPopover;
-(User *)currentUser;
@end

#import <UIKit/UIKit.h>

@interface PopoverUserViewController : UIViewController

@property (weak) id <PopoverUserDelegate> delegate;
@property (nonatomic, assign) BOOL isInEditingMode;

@end
