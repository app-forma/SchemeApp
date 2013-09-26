//
//  PopoverEventWrapperViewController.h
//  SchemeAppAdmin
//
//  Created by Rikard Karlsson on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

@protocol PopoverEventWrapperDelegate <NSObject>
-(void)dismissPopover;
-(EventWrapper *)currentEventWrapper;
@end

#import <UIKit/UIKit.h>

@interface PopoverEventWrapperViewController : UIViewController

@property (weak) id <PopoverEventWrapperDelegate> delegate;
@property (nonatomic, assign) BOOL isInEditingMode;

@end
