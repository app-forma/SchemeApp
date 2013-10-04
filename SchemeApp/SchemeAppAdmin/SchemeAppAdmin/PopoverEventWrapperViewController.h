//
//  PopoverEventWrapperViewController.h
//  SchemeAppAdmin
//
//  Created by Rikard Karlsson on 9/25/13.
//  Copyright (c) 2013 Marcus Norling. All rights reserved.
//

@protocol PopoverEventWrapperDelegate <NSObject>
@optional
-(EventWrapper *)popoverEventWrapperCurrentEventWrapper;
-(void)popoverEventWrapperCreateEventWrapper:(EventWrapper *)eventWrapper;
-(void)popoverEventWrapperUpdateEventWrapper:(EventWrapper *)eventWrapper;
@required
-(void)popoverEventWrapperDismissPopover;

@end

#import <UIKit/UIKit.h>

@interface PopoverEventWrapperViewController : UIViewController

@property (weak) id <PopoverEventWrapperDelegate> delegate;
@property (nonatomic, assign) BOOL isInEditingMode;

@end
